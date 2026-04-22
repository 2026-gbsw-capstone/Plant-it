package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.Plant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlantRepository extends JpaRepository<Plant, Long> {
}
