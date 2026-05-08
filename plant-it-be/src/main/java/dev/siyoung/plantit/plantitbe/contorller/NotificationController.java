package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.notification.NotificationSettingResponseDto;
import dev.siyoung.plantit.plantitbe.dto.notification.NotificationHistoryResponseDto;
import dev.siyoung.plantit.plantitbe.dto.notification.RegisterPushTokenRequestDto;
import dev.siyoung.plantit.plantitbe.dto.notification.SendPushRequestDto;
import dev.siyoung.plantit.plantitbe.dto.notification.UpdateNotificationSettingRequestDto;
import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.service.NotificationService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/notifications")
public class NotificationController {
    private final NotificationService notificationService;

    @Operation(summary = "알림 설정 조회", description = "JWT 사용자 기준으로 식물별 알림 설정을 조회합니다.")
    @GetMapping("/settings")
    public ResponseEntity<ApiResponse<List<NotificationSettingResponseDto>>> getSettings(@AuthenticationPrincipal Long userId) {
        return ResponseEntity.ok(ApiResponse.success("알림 설정을 조회했습니다.", notificationService.findSettings(userId)));
    }

    @Operation(summary = "알림 기록 조회", description = "JWT 사용자 기준으로 실제 발송된 알림 기록을 조회합니다.")
    @GetMapping("/histories")
    public ResponseEntity<ApiResponse<List<NotificationHistoryResponseDto>>> getHistories(@AuthenticationPrincipal Long userId) {
        return ResponseEntity.ok(ApiResponse.success("알림 기록을 조회했습니다.", notificationService.findHistories(userId)));
    }

    @Operation(summary = "알림 설정 수정", description = "식물별 알림 on/off와 사용자별 알림 시간을 수정합니다.")
    @PatchMapping("/settings")
    public ResponseEntity<ApiResponse<NotificationSettingResponseDto>> updateSetting(@AuthenticationPrincipal Long userId,
                                                                                    @Valid @RequestBody UpdateNotificationSettingRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("알림 설정이 수정되었습니다.", notificationService.updateSetting(userId, request)));
    }

    @Operation(summary = "푸시 토큰 등록", description = "JWT 사용자 기준으로 FCM 푸시 토큰을 저장합니다.")
    @PostMapping("/token")
    public ResponseEntity<ApiResponse<Void>> registerPushToken(@AuthenticationPrincipal Long userId,
                                                               @Valid @RequestBody RegisterPushTokenRequestDto request) {
        notificationService.registerPushToken(userId, request);
        return ResponseEntity.ok(ApiResponse.success("푸시 토큰이 등록되었습니다."));
    }

    @Operation(summary = "테스트 푸시 발송", description = "등록된 푸시 토큰으로 테스트 알림을 발송합니다.")
    @PostMapping("/test")
    public ResponseEntity<ApiResponse<String>> sendTestPush(@AuthenticationPrincipal Long userId,
                                                            @Valid @RequestBody SendPushRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("테스트 푸시 알림이 발송되었습니다.", notificationService.sendPush(userId, request)));
    }
}
