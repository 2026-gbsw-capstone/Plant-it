package dev.siyoung.plantit.plantitbe.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import dev.siyoung.plantit.plantitbe.dto.ai.AiAnalysisResponseDto;
import dev.siyoung.plantit.plantitbe.dto.ai.ChatRequestDto;
import dev.siyoung.plantit.plantitbe.dto.ai.ChatResponseDto;
import dev.siyoung.plantit.plantitbe.dto.ai.HealthCheckRequestDto;
import dev.siyoung.plantit.plantitbe.dto.ai.HealthCheckResponseDto;
import dev.siyoung.plantit.plantitbe.dto.ai.IdentifyPlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.ai.IdentifyPlantResponseDto;
import dev.siyoung.plantit.plantitbe.entity.AiPrompt.PromptType;
import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.PlantAiAnalysis;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.openai.OpenAiClient;
import dev.siyoung.plantit.plantitbe.repository.PlantAiAnalysisRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class AiService {
    private final PlantRepository plantRepository;
    private final PlantAiAnalysisRepository plantAiAnalysisRepository;
    private final OpenAiClient openAiClient;
    private final AiPromptService aiPromptService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public IdentifyPlantResponseDto identifyPlant(IdentifyPlantRequestDto request) {
        String response = openAiClient.createImageResponse(
                buildIdentifyPrompt(request),
                request.getImageUrl(),
                true
        );
        JsonNode json = parseJson(response);

        return IdentifyPlantResponseDto.builder()
                .speciesName(readText(json, "speciesName", readText(json, "species_name", "분석 불가")))
                .confidence(readDouble(json, "confidence", 0.0))
                .build();
    }

    public HealthCheckResponseDto healthCheck(Long userId, HealthCheckRequestDto request) {
        Plant plant = findPlant(userId, request.getPlantId());
        try {
            String response = openAiClient.createImageResponse(
                    buildHealthCheckPrompt(plant, request),
                    request.getImageUrl(),
                    true
            );
            JsonNode json = parseJson(response);
            Plant.HealthStatus healthStatus = readHealthStatus(json, plant.getHealthStatus());
            String summary = readText(json, "summary", response);
            List<String> tips = readStringList(json, "tips");

            plant.setHealthStatus(healthStatus);
            saveAnalysis(plant, request.getImageUrl(), PlantAiAnalysis.AnalysisType.HEALTH_ANALYSIS, summary, PlantAiAnalysis.ResultStatus.SUCCESS);

            return HealthCheckResponseDto.builder()
                    .healthStatus(healthStatus)
                    .summary(summary)
                    .tips(tips)
                    .build();
        } catch (PlantItException e) {
            saveAnalysis(plant, request.getImageUrl(), PlantAiAnalysis.AnalysisType.HEALTH_ANALYSIS, e.getMessage(), PlantAiAnalysis.ResultStatus.FAILED);
            throw e;
        }
    }

    /**
     * 성장 기록 저장 흐름에서 호출한다. 별도 트랜잭션으로 분리해, AI 분석이 실패해도
     * 기록 저장(호출자 트랜잭션)이 롤백되지 않도록 한다.
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public HealthCheckResponseDto healthCheckInNewTransaction(Long userId, HealthCheckRequestDto request) {
        return healthCheck(userId, request);
    }

    public ChatResponseDto chat(Long userId, ChatRequestDto request) {
        Plant plant = findPlant(userId, request.getPlantId());
        try {
            String answer = hasText(request.getImageUrl())
                    ? openAiClient.createImageResponse(buildChatPrompt(plant, request), request.getImageUrl(), false)
                    : openAiClient.createTextResponse(buildChatPrompt(plant, request), false);
            saveAnalysis(plant, request.getImageUrl(), PlantAiAnalysis.AnalysisType.CHAT, answer, PlantAiAnalysis.ResultStatus.SUCCESS);

            return ChatResponseDto.builder()
                    .answer(answer)
                    .build();
        } catch (PlantItException e) {
            saveAnalysis(plant, request.getImageUrl(), PlantAiAnalysis.AnalysisType.CHAT, e.getMessage(), PlantAiAnalysis.ResultStatus.FAILED);
            throw e;
        }
    }

    @Transactional(readOnly = true)
    public List<AiAnalysisResponseDto> findAnalyses(Long userId, Long plantId) {
        findPlant(userId, plantId);
        return plantAiAnalysisRepository.findByPlantId(plantId).stream()
                .map(EntityDtoMapper::toDto)
                .toList();
    }

    private Plant findPlant(Long userId, Long plantId) {
        return plantRepository.findByIdAndUserId(plantId, userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "식물을 찾을 수 없습니다."));
    }

    private void saveAnalysis(Plant plant,
                              String imageUrl,
                              PlantAiAnalysis.AnalysisType analysisType,
                              String resultText,
                              PlantAiAnalysis.ResultStatus resultStatus) {
        plantAiAnalysisRepository.save(PlantAiAnalysis.builder()
                .plant(plant)
                .imageUrl(imageUrl)
                .analysisType(analysisType)
                .resultText(resultText)
                .resultStatus(resultStatus)
                .build());
    }

    private String buildIdentifyPrompt(IdentifyPlantRequestDto request) {
        return aiPromptService.getPrompt(PromptType.IDENTIFY) + "\n\nImage URL: " + request.getImageUrl()
                + "\nReturn JSON only. Example: {\"speciesName\":\"Monstera deliciosa\",\"confidence\":0.92}";
    }

    private String buildHealthCheckPrompt(Plant plant, HealthCheckRequestDto request) {
        return aiPromptService.getPrompt(PromptType.HEALTH_CHECK)
                + "\n\nPlant name: " + nullToBlank(plant.getName())
                + "\nSpecies name: " + nullToBlank(plant.getSpeciesName())
                + "\nMemo: " + nullToBlank(plant.getMemo())
                + "\nImage URL: " + request.getImageUrl()
                + "\nReturn JSON only. Example: {\"healthStatus\":\"WARNING\",\"summary\":\"...\",\"tips\":[\"...\"]}";
    }

    private String buildChatPrompt(Plant plant, ChatRequestDto request) {
        return aiPromptService.getPrompt(PromptType.CHAT)
                + "\n\nPlant name: " + nullToBlank(plant.getName())
                + "\nSpecies name: " + nullToBlank(plant.getSpeciesName())
                + "\nHealth status: " + plant.getHealthStatus()
                + "\nMemo: " + nullToBlank(plant.getMemo())
                + (hasText(request.getImageUrl()) ? "\nImage URL: " + request.getImageUrl() : "")
                + "\nQuestion: " + request.getQuestion();
    }

    private JsonNode parseJson(String text) {
        try {
            return objectMapper.readTree(cleanJson(text));
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "AI 응답 JSON 파싱에 실패했습니다.");
        }
    }

    private String cleanJson(String text) {
        String trimmed = text == null ? "" : text.trim();
        if (trimmed.startsWith("```")) {
            trimmed = trimmed.replaceFirst("^```json\\s*", "")
                    .replaceFirst("^```\\s*", "")
                    .replaceFirst("\\s*```$", "");
        }
        return trimmed;
    }

    private String readText(JsonNode json, String field, String defaultValue) {
        JsonNode value = json.get(field);
        return value == null || value.isNull() ? defaultValue : value.asText(defaultValue);
    }

    private Double readDouble(JsonNode json, String field, Double defaultValue) {
        JsonNode value = json.get(field);
        return value == null || !value.isNumber() ? defaultValue : value.asDouble();
    }

    private Plant.HealthStatus readHealthStatus(JsonNode json, Plant.HealthStatus defaultValue) {
        try {
            return Plant.HealthStatus.valueOf(readText(json, "healthStatus", defaultValue.name()));
        } catch (IllegalArgumentException e) {
            return defaultValue;
        }
    }

    private List<String> readStringList(JsonNode json, String field) {
        JsonNode value = json.get(field);
        if (value == null || !value.isArray()) {
            return List.of();
        }

        List<String> values = new ArrayList<>();
        value.forEach(item -> values.add(item.asText()));
        return values;
    }

    private String nullToBlank(String value) {
        return value == null ? "" : value;
    }

    private boolean hasText(String value) {
        return value != null && !value.isBlank();
    }
}
