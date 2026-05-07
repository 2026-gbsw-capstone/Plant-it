package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.PlantDiary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PlantDiaryRepository extends JpaRepository<PlantDiary, Long> {
    List<PlantDiary> findByPlantId(Long plantId);
    Optional<PlantDiary> findByIdAndPlantId(Long id, Long plantId);
}
