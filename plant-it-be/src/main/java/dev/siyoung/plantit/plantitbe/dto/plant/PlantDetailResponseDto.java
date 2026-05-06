package dev.siyoung.plantit.plantitbe.dto.plant;

import dev.siyoung.plantit.plantitbe.entity.Plant.HealthStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlantDetailResponseDto {
    private Long id;
    private String name;
    private String speciesName;
    private String plantImageUrl;
    private Integer wateringCycleDays;
    private Integer fertilizerCycleDays;
    private LocalDateTime lastWateredAt;
    private LocalDateTime lastFertilizedAt;
    private HealthStatus healthStatus;
    private String memo;
}
