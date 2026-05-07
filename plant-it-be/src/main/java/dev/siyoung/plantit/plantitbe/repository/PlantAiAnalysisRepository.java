package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.PlantAiAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PlantAiAnalysisRepository extends JpaRepository<PlantAiAnalysis, Long> {
    List<PlantAiAnalysis> findByPlantId(Long plantId);
}
