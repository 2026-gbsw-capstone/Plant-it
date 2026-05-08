package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.ai.ChatRequestDto;
import dev.siyoung.plantit.plantitbe.dto.ai.ChatResponseDto;
import dev.siyoung.plantit.plantitbe.dto.ai.HealthCheckRequestDto;
import dev.siyoung.plantit.plantitbe.dto.ai.HealthCheckResponseDto;
import dev.siyoung.plantit.plantitbe.dto.ai.IdentifyPlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.ai.IdentifyPlantResponseDto;
import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.service.AiService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/ai")
public class AiController {
    private final AiService aiService;

    @PostMapping("/plants/identify")
    public ResponseEntity<ApiResponse<IdentifyPlantResponseDto>> identifyPlant(@Valid @RequestBody IdentifyPlantRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("식물 종 분석이 완료되었습니다.", aiService.identifyPlant(request)));
    }

    @PostMapping("/plants/health-check")
    public ResponseEntity<ApiResponse<HealthCheckResponseDto>> healthCheck(@AuthenticationPrincipal Long userId,
                                                                           @Valid @RequestBody HealthCheckRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("건강 상태 분석이 완료되었습니다.", aiService.healthCheck(userId, request)));
    }

    @PostMapping("/chat")
    public ResponseEntity<ApiResponse<ChatResponseDto>> chat(@AuthenticationPrincipal Long userId,
                                                             @Valid @RequestBody ChatRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("AI 답변이 생성되었습니다.", aiService.chat(userId, request)));
    }
}
