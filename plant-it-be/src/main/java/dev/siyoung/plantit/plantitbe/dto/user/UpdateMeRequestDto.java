package dev.siyoung.plantit.plantitbe.dto.user;

import dev.siyoung.plantit.plantitbe.dto.common.ValidationPatterns;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMeRequestDto {
    @Pattern(regexp = ValidationPatterns.NICKNAME, message = ValidationPatterns.NICKNAME_MESSAGE)
    private String nickname;

    private String profileImageUrl;
}
