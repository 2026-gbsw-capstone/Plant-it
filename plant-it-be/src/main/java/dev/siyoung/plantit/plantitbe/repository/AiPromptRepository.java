package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.AiPrompt;
import dev.siyoung.plantit.plantitbe.entity.AiPrompt.PromptType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AiPromptRepository extends JpaRepository<AiPrompt, Long> {
    Optional<AiPrompt> findByPromptType(PromptType promptType);
}
