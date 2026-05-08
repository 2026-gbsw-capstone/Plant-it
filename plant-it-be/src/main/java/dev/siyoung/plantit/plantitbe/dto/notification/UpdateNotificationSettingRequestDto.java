package dev.siyoung.plantit.plantitbe.dto.notification;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateNotificationSettingRequestDto {
    @NotNull(message = "식물 ID는 필수입니다.")
    private Long plantId;

    private Boolean wateringEnabled;
    private Boolean fertilizerEnabled;
    private Boolean growthRecordEnabled;
    private LocalTime notificationTime;
}
