package dev.siyoung.plantit.plantitbe.dto.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MeResponseDto {
    private Long id;
    private String email;
    private String nickname;
    private String profileImageUrl;
}
