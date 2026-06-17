package dev.siyoung.plantit.plantitbe.service;

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
import dev.siyoung.plantit.plantitbe.entity.PasswordResetToken;
import dev.siyoung.plantit.plantitbe.entity.RefreshToken;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.firebase.FirebaseService;
import dev.siyoung.plantit.plantitbe.firebase.FirebaseUserInfo;
import dev.siyoung.plantit.plantitbe.repository.PasswordResetTokenRepository;
import dev.siyoung.plantit.plantitbe.repository.RefreshTokenRepository;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import dev.siyoung.plantit.plantitbe.security.JwtTokenProvider;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class AuthService {
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final FirebaseService firebaseService;
    private final EmailService emailService;

    public SignupResponseDto signup(SignupRequestDto request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new PlantItException(HttpStatus.CONFLICT, "이미 가입된 이메일입니다.");
        }
        if (userRepository.existsByNickname(request.getNickname())) {
            throw new PlantItException(HttpStatus.CONFLICT, "이미 사용 중인 닉네임입니다.");
        }

        User user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .nickname(request.getNickname())
                .loginType(User.LoginType.EMAIL)
                .build();

        return EntityDtoMapper.toSignupDto(userRepository.save(user));
    }

    public TokenResponseDto login(LoginRequestDto request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));
        if (user.getPassword() == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "이메일 또는 비밀번호가 올바르지 않습니다.");
        }

        return createTokenResponse(user);
    }

    public GoogleLoginResponseDto googleLogin(GoogleLoginRequestDto request) {
        FirebaseUserInfo firebaseUser = firebaseService.verifyIdToken(request.getIdToken());
        String email = firebaseUser.getEmail();
        if (email == null || email.isBlank()) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "Firebase 토큰에 이메일 정보가 없습니다.");
        }

        boolean isNewUser = userRepository.findByEmail(email).isEmpty();
        User user = userRepository.findByEmail(email)
                .orElseGet(() -> userRepository.save(User.builder()
                        .email(email)
                        .nickname(createUniqueNickname(firebaseUser.getName()))
                        .profileImageUrl(firebaseUser.getPicture())
                        .loginType(User.LoginType.GOOGLE)
                        .build()));

        return GoogleLoginResponseDto.builder()
                .accessToken(jwtTokenProvider.createAccessToken(user.getId()))
                .refreshToken(createAndSaveRefreshToken(user))
                .isNewUser(isNewUser)
                .build();
    }

    public PasswordResetRequestResponseDto requestPasswordReset(PasswordResetRequestDto request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));
        String code = createCode();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(10);

        passwordResetTokenRepository.save(PasswordResetToken.builder()
                .user(user)
                .code(code)
                .expiresAt(expiresAt)
                .build());
        emailService.sendPasswordResetCode(user.getEmail(), code, expiresAt);

        return PasswordResetRequestResponseDto.builder()
                .email(user.getEmail())
                .expiresAt(expiresAt)
                .build();
    }

    public PasswordResetVerifyResponseDto verifyPasswordReset(PasswordResetVerifyRequestDto request) {
        PasswordResetToken passwordResetToken = passwordResetTokenRepository
                .findTopByUserEmailAndCodeAndUsedFalseOrderByCreatedAtDesc(request.getEmail(), request.getCode())
                .orElseThrow(() -> new PlantItException(HttpStatus.BAD_REQUEST, "인증 코드가 올바르지 않습니다."));

        if (passwordResetToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "인증 코드가 만료되었습니다.");
        }

        String resetToken = UUID.randomUUID().toString();
        passwordResetToken.setVerified(true);
        passwordResetToken.setResetToken(resetToken);

        return PasswordResetVerifyResponseDto.builder()
                .resetToken(resetToken)
                .build();
    }

    public void confirmPasswordReset(PasswordResetConfirmRequestDto request) {
        PasswordResetToken passwordResetToken = passwordResetTokenRepository
                .findByResetTokenAndVerifiedTrueAndUsedFalse(request.getResetToken())
                .orElseThrow(() -> new PlantItException(HttpStatus.BAD_REQUEST, "비밀번호 재설정 토큰이 유효하지 않습니다."));

        if (passwordResetToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "비밀번호 재설정 토큰이 만료되었습니다.");
        }

        User user = passwordResetToken.getUser();
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        passwordResetToken.setUsed(true);
    }

    public TokenResponseDto refreshToken(RefreshTokenRequestDto request) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(request.getRefreshToken())
                .orElseThrow(() -> new PlantItException(HttpStatus.UNAUTHORIZED, "Refresh token이 유효하지 않습니다."));

        if (Boolean.TRUE.equals(refreshToken.getRevoked()) || refreshToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "Refresh token이 만료되었거나 폐기되었습니다.");
        }

        refreshToken.setRevoked(true);
        return createTokenResponse(refreshToken.getUser());
    }

    public void logout(LogoutRequestDto request) {
        refreshTokenRepository.findByToken(request.getRefreshToken())
                .ifPresent(refreshToken -> refreshToken.setRevoked(true));
    }

    private TokenResponseDto createTokenResponse(User user) {
        return TokenResponseDto.builder()
                .accessToken(jwtTokenProvider.createAccessToken(user.getId()))
                .refreshToken(createAndSaveRefreshToken(user))
                .build();
    }

    private String createAndSaveRefreshToken(User user) {
        String refreshToken = jwtTokenProvider.createRefreshToken(user.getId());
        refreshTokenRepository.save(RefreshToken.builder()
                .user(user)
                .token(refreshToken)
                .expiresAt(jwtTokenProvider.getExpiresAt(refreshToken))
                .build());
        return refreshToken;
    }

    private String createCode() {
        return String.format("%06d", SECURE_RANDOM.nextInt(1_000_000));
    }

    private String createUniqueNickname(String nickname) {
        String baseNickname = nickname == null || nickname.isBlank() ? "google-user" : nickname.trim();
        if (baseNickname.length() > 45) {
            baseNickname = baseNickname.substring(0, 45);
        }
        if (!userRepository.existsByNickname(baseNickname)) {
            return baseNickname;
        }

        for (int i = 0; i < 20; i++) {
            String candidate = baseNickname + "-" + SECURE_RANDOM.nextInt(10_000);
            if (!userRepository.existsByNickname(candidate)) {
                return candidate;
            }
        }

        throw new PlantItException(HttpStatus.CONFLICT, "사용 가능한 닉네임을 생성하지 못했습니다.");
    }
}
