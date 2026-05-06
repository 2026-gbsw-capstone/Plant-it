package dev.siyoung.plantit.plantitbe.dto.ai;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IdentifyPlantResponseDto {
    private String speciesName;
    private Double confidence;
}
