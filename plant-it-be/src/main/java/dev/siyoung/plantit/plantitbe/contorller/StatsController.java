package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.dto.stat.UsageStatsResponseDto;
import dev.siyoung.plantit.plantitbe.service.StatsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/stats")
public class StatsController {
    private final StatsService statsService;

    @GetMapping("/usage")
    public ResponseEntity<ApiResponse<UsageStatsResponseDto>> getUsageStats(@AuthenticationPrincipal Long userId) {
        return ResponseEntity.ok(ApiResponse.success("사용 통계를 조회했습니다.", statsService.findUsageStats(userId)));
    }
}
