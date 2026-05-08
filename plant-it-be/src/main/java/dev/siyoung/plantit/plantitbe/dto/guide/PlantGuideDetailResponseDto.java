package dev.siyoung.plantit.plantitbe.dto.guide;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlantGuideDetailResponseDto {
    private Long id;
    private String speciesName;
    private String difficulty;
    private String sunlight;
    private String watering;
    private String fertilizer;
    private String humidity;
    private String temperature;
    private String toxicity;
    private String description;
    private String imageUrl;
}
