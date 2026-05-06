package dev.siyoung.plantit.plantitbe.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PasswordResetVerifyRequestDto {
    private String email;
    private String code;
}
