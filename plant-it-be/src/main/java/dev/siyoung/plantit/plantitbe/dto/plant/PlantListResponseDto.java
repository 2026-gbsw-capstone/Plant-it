package dev.siyoung.plantit.plantitbe.dto.plant;

import dev.siyoung.plantit.plantitbe.entity.Plant.HealthStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlantListResponseDto {
    private Long id;
    private String name;
    private String speciesName;
    private String plantImageUrl;
    private HealthStatus healthStatus;
    private LocalDate nextWateringDate;
}
