package dev.siyoung.plantit.plantitbe.dto.auth;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class EmailVerificationRequestResponseDto {
    private String email;
    private LocalDateTime expiresAt;
}
