package dev.siyoung.plantit.plantitbe.dto.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class LogoutRequestDto {
    @NotBlank(message = "Refresh token은 필수입니다.")
    private String refreshToken;
}
