package dev.siyoung.plantit.plantitbe.dto.user;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMeRequestDto {
    @Size(max = 50, message = "닉네임은 50자 이하여야 합니다.")
    private String nickname;

    private String profileImageUrl;
}
