package dev.siyoung.plantit.plantitbe.dto.user;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class VerifyPasswordRequestDto {
    @NotBlank(message = "비밀번호를 입력해 주세요.")
    private String password;
}
