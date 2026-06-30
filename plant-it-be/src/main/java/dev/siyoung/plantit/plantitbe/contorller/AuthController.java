package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.auth.EmailVerificationConfirmRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.EmailVerificationRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.EmailVerificationRequestResponseDto;
import dev.siyoung.plantit.plantitbe.dto.auth.GoogleLoginRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.GoogleLoginResponseDto;
import dev.siyoung.plantit.plantitbe.dto.auth.LoginRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.LogoutRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.PasswordResetConfirmRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.PasswordResetRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.PasswordResetRequestResponseDto;
import dev.siyoung.plantit.plantitbe.dto.auth.PasswordResetVerifyRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.PasswordResetVerifyResponseDto;
import dev.siyoung.plantit.plantitbe.dto.auth.RefreshTokenRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.SignupRequestDto;
import dev.siyoung.plantit.plantitbe.dto.auth.SignupResponseDto;
import dev.siyoung.plantit.plantitbe.dto.auth.TokenResponseDto;
import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/auth")
public class AuthController {
    private final AuthService authService;

    @PostMapping("/signup/email/request")
    public ResponseEntity<ApiResponse<EmailVerificationRequestResponseDto>> requestSignupEmailVerification(@Valid @RequestBody EmailVerificationRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("이메일 인증 코드가 발송되었습니다.", authService.requestSignupEmailVerification(request)));
    }

    @PostMapping("/signup/email/verify")
    public ResponseEntity<ApiResponse<Void>> verifySignupEmail(@Valid @RequestBody EmailVerificationConfirmRequestDto request) {
        authService.verifySignupEmail(request);
        return ResponseEntity.ok(ApiResponse.success("이메일 인증이 완료되었습니다."));
    }

    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<SignupResponseDto>> signup(@Valid @RequestBody SignupRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("회원가입이 완료되었습니다.", authService.signup(request)));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<TokenResponseDto>> login(@Valid @RequestBody LoginRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("로그인에 성공했습니다.", authService.login(request)));
    }

    @PostMapping("/google")
    public ResponseEntity<ApiResponse<GoogleLoginResponseDto>> googleLogin(@Valid @RequestBody GoogleLoginRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("구글 로그인에 성공했습니다.", authService.googleLogin(request)));
    }

    @PostMapping("/password/reset/request")
    public ResponseEntity<ApiResponse<PasswordResetRequestResponseDto>> requestPasswordReset(@Valid @RequestBody PasswordResetRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("비밀번호 재설정 인증 코드가 발급되었습니다.", authService.requestPasswordReset(request)));
    }

    @PostMapping("/password/reset/verify")
    public ResponseEntity<ApiResponse<PasswordResetVerifyResponseDto>> verifyPasswordReset(@Valid @RequestBody PasswordResetVerifyRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("인증 코드가 확인되었습니다.", authService.verifyPasswordReset(request)));
    }

    @PostMapping("/password/reset/confirm")
    public ResponseEntity<ApiResponse<Void>> confirmPasswordReset(@Valid @RequestBody PasswordResetConfirmRequestDto request) {
        authService.confirmPasswordReset(request);
        return ResponseEntity.ok(ApiResponse.success("비밀번호가 재설정되었습니다."));
    }

    @PostMapping("/token/refresh")
    public ResponseEntity<ApiResponse<TokenResponseDto>> refreshToken(@Valid @RequestBody RefreshTokenRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("토큰이 재발급되었습니다.", authService.refreshToken(request)));
    }

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(@Valid @RequestBody LogoutRequestDto request) {
        authService.logout(request);
        return ResponseEntity.ok(ApiResponse.success("로그아웃되었습니다."));
    }
}
