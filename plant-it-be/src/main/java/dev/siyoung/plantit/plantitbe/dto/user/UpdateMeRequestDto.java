package dev.siyoung.plantit.plantitbe.dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMeRequestDto {
    private String nickname;
    private String profileImageUrl;
}
