package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.admin.AiPromptFormDto;
import dev.siyoung.plantit.plantitbe.entity.AiPrompt;
import dev.siyoung.plantit.plantitbe.entity.AiPrompt.PromptType;
import dev.siyoung.plantit.plantitbe.repository.AiPromptRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class AiPromptService {
    private final AiPromptRepository aiPromptRepository;

    @PostConstruct
    public void initializeDefaults() {
        Arrays.stream(PromptType.values()).forEach(this::findOrCreate);
    }

    @Transactional(readOnly = true)
    public List<AiPrompt> findAll() {
        return aiPromptRepository.findAll().stream()
                .sorted((left, right) -> left.getPromptType().compareTo(right.getPromptType()))
                .toList();
    }

    @Transactional(readOnly = true)
    public AiPrompt findByType(PromptType promptType) {
        return findOrCreate(promptType);
    }

    @Transactional(readOnly = true)
    public String getPrompt(PromptType promptType) {
        return findOrCreate(promptType).getContent();
    }

    public AiPrompt update(PromptType promptType, AiPromptFormDto form) {
        AiPrompt prompt = findOrCreate(promptType);
        prompt.setTitle(form.getTitle());
        prompt.setContent(form.getContent());
        return prompt;
    }

    public AiPromptFormDto toForm(AiPrompt prompt) {
        return AiPromptFormDto.builder()
                .title(prompt.getTitle())
                .content(prompt.getContent())
                .build();
    }

    private AiPrompt findOrCreate(PromptType promptType) {
        return aiPromptRepository.findByPromptType(promptType)
                .orElseGet(() -> aiPromptRepository.save(AiPrompt.builder()
                        .promptType(promptType)
                        .title(defaultTitle(promptType))
                        .content(defaultContent(promptType))
                        .build()));
    }

    private String defaultTitle(PromptType promptType) {
        return switch (promptType) {
            case IDENTIFY -> "식물 종 식별";
            case HEALTH_CHECK -> "식물 건강 분석";
            case CHAT -> "식물 상담 채팅";
        };
    }

    private String defaultContent(PromptType promptType) {
        return switch (promptType) {
            case IDENTIFY -> "Return JSON only with speciesName and confidence.";
            case HEALTH_CHECK -> "Return JSON only with healthStatus, summary, and tips. healthStatus must be GOOD, WARNING, or DANGER.";
            case CHAT -> "Answer as a helpful plant care assistant.";
        };
    }
}
