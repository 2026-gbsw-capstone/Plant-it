package dev.siyoung.plantit.plantitbe.dto.ai;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class HealthCheckRequestDto {
    @NotNull(message = "식물 ID는 필수입니다.")
    private Long plantId;

    @NotBlank(message = "이미지 URL은 필수입니다.")
    private String imageUrl;
}
