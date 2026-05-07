package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.Plant;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PlantRepository extends JpaRepository<Plant, Long> {
    List<Plant> findByUserId(Long userId);
}
