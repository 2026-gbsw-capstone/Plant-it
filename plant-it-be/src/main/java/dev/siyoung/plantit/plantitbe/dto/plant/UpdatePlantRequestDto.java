package dev.siyoung.plantit.plantitbe.dto.plant;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdatePlantRequestDto {
    private String name;
    private String speciesName;
    private String plantImageUrl;
    private Integer wateringCycleDays;
    private Integer fertilizerCycleDays;
    private String memo;
}
