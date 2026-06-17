package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.PlantCareGuide;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PlantCareGuideRepository extends JpaRepository<PlantCareGuide, Long> {
    @Query("""
            select g
            from PlantCareGuide g
            where (:keyword is null
                   or lower(g.speciesName) like lower(concat('%', :keyword, '%'))
                   or lower(g.description) like lower(concat('%', :keyword, '%')))
              and (:sunlight is null or lower(g.sunlight) like lower(concat('%', :sunlight, '%')))
            order by g.speciesName asc
            """)
    List<PlantCareGuide> search(String keyword, String sunlight);
}
