package dev.siyoung.plantit.plantitbe.dto.ai;

import dev.siyoung.plantit.plantitbe.entity.Plant.HealthStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HealthCheckResponseDto {
    private HealthStatus healthStatus;
    private String summary;
    private List<String> tips;
}
