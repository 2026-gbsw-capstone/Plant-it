package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.PlantDiary;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlantDiaryRepository extends JpaRepository<PlantDiary, Long> {
}
