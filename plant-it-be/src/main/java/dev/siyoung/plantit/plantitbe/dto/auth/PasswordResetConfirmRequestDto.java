package dev.siyoung.plantit.plantitbe.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PasswordResetConfirmRequestDto {
    private String resetToken;
    private String newPassword;
}
