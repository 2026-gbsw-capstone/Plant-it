package dev.siyoung.plantit.plantitbe.dto.guide;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PlantGuideSearchRequestDto {
    private String keyword;
    private String sunlight;
}
