package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.dto.user.MeResponseDto;
import dev.siyoung.plantit.plantitbe.dto.user.UpdateMeRequestDto;
import dev.siyoung.plantit.plantitbe.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserService userService;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<MeResponseDto>>> getAllUsers() {
        return ResponseEntity.ok(ApiResponse.success("사용자 목록을 조회했습니다.", userService.findAllUsers()));
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<MeResponseDto>> getMe(@AuthenticationPrincipal Long userId) {
        return ResponseEntity.ok(ApiResponse.success("내 정보를 조회했습니다.", userService.fineUserById(userId)));
    }

    @PatchMapping("/me")
    public ResponseEntity<ApiResponse<MeResponseDto>> updateMe(@AuthenticationPrincipal Long userId,
                                                               @Valid @RequestBody UpdateMeRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("내 정보가 수정되었습니다.", userService.updateUser(userId, request)));
    }
}
