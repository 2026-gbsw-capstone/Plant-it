package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.dto.user.MeResponseDto;
import dev.siyoung.plantit.plantitbe.dto.user.UpdateMeRequestDto;
import dev.siyoung.plantit.plantitbe.dto.user.ChangePasswordRequestDto;
import dev.siyoung.plantit.plantitbe.dto.user.VerifyPasswordRequestDto;
import dev.siyoung.plantit.plantitbe.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<MeResponseDto>> getMe(@AuthenticationPrincipal Long userId) {
        return ResponseEntity.ok(ApiResponse.success("내 정보를 조회했습니다.", userService.fineUserById(userId)));
    }

    @PatchMapping("/me")
    public ResponseEntity<ApiResponse<MeResponseDto>> updateMe(@AuthenticationPrincipal Long userId,
                                                               @Valid @RequestBody UpdateMeRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("내 정보가 수정되었습니다.", userService.updateUser(userId, request)));
    }

    @PatchMapping("/me/password")
    public ResponseEntity<ApiResponse<Void>> changePassword(@AuthenticationPrincipal Long userId,
                                                            @Valid @RequestBody ChangePasswordRequestDto request) {
        userService.changePassword(userId, request.getCurrentPassword(), request.getNewPassword());
        return ResponseEntity.ok(ApiResponse.success("비밀번호가 변경되었습니다."));
    }

    @DeleteMapping("/me")
    public ResponseEntity<ApiResponse<Void>> deleteAccount(@AuthenticationPrincipal Long userId,
                                                           @Valid @RequestBody VerifyPasswordRequestDto request) {
        userService.deleteAccount(userId, request.getPassword());
        return ResponseEntity.ok(ApiResponse.success("계정이 삭제되었습니다."));
    }

    @DeleteMapping("/me/data")
    public ResponseEntity<ApiResponse<Void>> resetData(@AuthenticationPrincipal Long userId,
                                                       @Valid @RequestBody VerifyPasswordRequestDto request) {
        userService.resetData(userId, request.getPassword());
        return ResponseEntity.ok(ApiResponse.success("데이터가 초기화되었습니다."));
    }
}
