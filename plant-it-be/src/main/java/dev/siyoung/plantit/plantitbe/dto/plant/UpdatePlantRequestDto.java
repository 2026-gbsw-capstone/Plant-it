package dev.siyoung.plantit.plantitbe.dto.plant;

import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdatePlantRequestDto {
    @Size(max = 100, message = "식물 이름은 100자 이하여야 합니다.")
    private String name;

    @Size(max = 100, message = "식물 종 이름은 100자 이하여야 합니다.")
    private String speciesName;

    private String plantImageUrl;

    @Positive(message = "물주기 주기는 1일 이상이어야 합니다.")
    private Integer wateringCycleDays;

    @Positive(message = "비료 주기는 1일 이상이어야 합니다.")
    private Integer fertilizerCycleDays;

    private String memo;
}
