package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.Plant.HealthStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface PlantRepository extends JpaRepository<Plant, Long> {
    List<Plant> findByUserId(Long userId);
    Optional<Plant> findByIdAndUserId(Long id, Long userId);
    Optional<Plant> findTopByUserIdOrderByRegisteredAtAsc(Long userId);

    @Query("""
            select p
            from Plant p
            where p.user.id = :userId
              and (:keyword is null
                   or lower(p.name) like lower(concat('%', :keyword, '%'))
                   or lower(p.speciesName) like lower(concat('%', :keyword, '%')))
              and (:healthStatus is null or p.healthStatus = :healthStatus)
            order by p.registeredAt desc
            """)
    List<Plant> searchByUser(Long userId, String keyword, HealthStatus healthStatus);
}
