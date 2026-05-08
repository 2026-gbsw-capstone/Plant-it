package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.PlantCareHistory;
import dev.siyoung.plantit.plantitbe.entity.PlantCareHistory.CareType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlantCareHistoryRepository extends JpaRepository<PlantCareHistory, Long> {
    long countByPlantUserIdAndCareType(Long userId, CareType careType);
}
