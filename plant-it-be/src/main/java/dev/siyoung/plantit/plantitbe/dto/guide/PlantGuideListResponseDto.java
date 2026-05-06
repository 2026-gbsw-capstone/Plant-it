package dev.siyoung.plantit.plantitbe.dto.guide;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlantGuideListResponseDto {
    private Long id;
    private String speciesName;
    private String difficulty;
    private String imageUrl;
}
