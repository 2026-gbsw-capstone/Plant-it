package dev.siyoung.plantit.plantitbe.dto.notification;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterPushTokenRequestDto {
    @NotBlank(message = "푸시 토큰은 필수입니다.")
    private String pushToken;
}
