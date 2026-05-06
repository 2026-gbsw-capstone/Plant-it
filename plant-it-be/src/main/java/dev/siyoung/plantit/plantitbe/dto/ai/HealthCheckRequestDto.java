package dev.siyoung.plantit.plantitbe.dto.ai;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class HealthCheckRequestDto {
    private Long plantId;
    private String imageUrl;
}
