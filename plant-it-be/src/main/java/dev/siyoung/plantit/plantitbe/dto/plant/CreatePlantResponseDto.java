package dev.siyoung.plantit.plantitbe.dto.plant;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreatePlantResponseDto {
    private Long plantId;
}
