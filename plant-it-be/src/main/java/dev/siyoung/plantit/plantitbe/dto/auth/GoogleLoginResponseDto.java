package dev.siyoung.plantit.plantitbe.dto.auth;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GoogleLoginResponseDto {
    private String accessToken;
    private String refreshToken;
    @JsonProperty("isNewUser")
    private Boolean isNewUser;
}
