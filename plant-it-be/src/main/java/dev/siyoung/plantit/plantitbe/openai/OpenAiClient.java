package dev.siyoung.plantit.plantitbe.openai;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestClientResponseException;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Component
public class OpenAiClient {
    private final String apiKey;
    private final String model;
    private final int maxRetries;
    private final RestClient restClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public OpenAiClient(@Value("${openai.api-key:}") String apiKey,
                        @Value("${openai.model:gpt-4o-mini}") String model,
                        @Value("${openai.max-retries:2}") int maxRetries) {
        this.apiKey = apiKey;
        this.model = model;
        this.maxRetries = maxRetries;
        this.restClient = RestClient.builder()
                .baseUrl("https://api.openai.com")
                .build();
    }

    public String createTextResponse(String prompt, boolean jsonMode) {
        Map<String, Object> body = createBaseRequest((Object) prompt, jsonMode);
        return request(body);
    }

    public String createImageResponse(String prompt, String imageUrl, boolean jsonMode) {
        Map<String, Object> textContent = new LinkedHashMap<>();
        textContent.put("type", "input_text");
        textContent.put("text", prompt);

        Map<String, Object> imageContent = new LinkedHashMap<>();
        imageContent.put("type", "input_image");
        imageContent.put("image_url", imageUrl);
        imageContent.put("detail", "auto");

        Map<String, Object> message = new LinkedHashMap<>();
        message.put("role", "user");
        message.put("content", List.of(textContent, imageContent));

        Map<String, Object> body = createBaseRequest(List.of(message), jsonMode);
        return request(body);
    }

    private Map<String, Object> createBaseRequest(Object input, boolean jsonMode) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("model", model);
        body.put("input", input);
        body.put("store", false);

        if (jsonMode) {
            body.put("text", Map.of("format", Map.of("type", "json_object")));
        }

        return body;
    }

    private String request(Map<String, Object> body) {
        if (apiKey == null || apiKey.isBlank()) {
            throw new PlantItException(HttpStatus.SERVICE_UNAVAILABLE, "OpenAI API 키가 설정되지 않았습니다.");
        }

        int attempts = Math.max(1, maxRetries + 1);
        for (int attempt = 1; attempt <= attempts; attempt++) {
            try {
                String responseBody = restClient.post()
                        .uri("/v1/responses")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + apiKey)
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(body)
                        .retrieve()
                        .body(String.class);

                return extractOutputText(parseResponse(responseBody));
            } catch (RestClientResponseException e) {
                if (!shouldRetry(e.getStatusCode().value()) || attempt == attempts) {
                    throw new PlantItException(HttpStatus.BAD_GATEWAY, "OpenAI API 호출에 실패했습니다.");
                }
                sleepBeforeRetry(attempt);
            } catch (RestClientException e) {
                if (attempt == attempts) {
                    throw new PlantItException(HttpStatus.BAD_GATEWAY, "OpenAI API 호출에 실패했습니다.");
                }
                sleepBeforeRetry(attempt);
            }
        }

        throw new PlantItException(HttpStatus.BAD_GATEWAY, "OpenAI API 호출에 실패했습니다.");
    }

    private JsonNode parseResponse(String responseBody) {
        try {
            return objectMapper.readTree(responseBody);
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "OpenAI 응답 파싱에 실패했습니다.");
        }
    }

    private boolean shouldRetry(int statusCode) {
        return statusCode == 408 || statusCode == 429 || statusCode >= 500;
    }

    private void sleepBeforeRetry(int attempt) {
        try {
            Thread.sleep(300L * attempt);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private String extractOutputText(JsonNode response) {
        if (response == null) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "OpenAI 응답이 비어 있습니다.");
        }

        JsonNode outputText = response.get("output_text");
        if (outputText != null && outputText.isTextual()) {
            return outputText.asText();
        }

        List<String> texts = new ArrayList<>();
        JsonNode output = response.get("output");
        if (output != null && output.isArray()) {
            output.forEach(item -> {
                JsonNode content = item.get("content");
                if (content != null && content.isArray()) {
                    content.forEach(contentItem -> {
                        JsonNode text = contentItem.get("text");
                        if (text != null && text.isTextual()) {
                            texts.add(text.asText());
                        }
                    });
                }
            });
        }

        if (texts.isEmpty()) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "OpenAI 응답 텍스트를 찾을 수 없습니다.");
        }

        return String.join("\n", texts);
    }
}
