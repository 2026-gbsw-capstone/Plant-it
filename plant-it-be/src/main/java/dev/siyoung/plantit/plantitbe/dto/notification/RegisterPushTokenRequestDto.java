package dev.siyoung.plantit.plantitbe.dto.notification;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterPushTokenRequestDto {
    private String pushToken;
}
