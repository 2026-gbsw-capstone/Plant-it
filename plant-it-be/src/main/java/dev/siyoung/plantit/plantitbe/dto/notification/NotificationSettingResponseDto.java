package dev.siyoung.plantit.plantitbe.dto.notification;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationSettingResponseDto {
    private Long plantId;
    private Boolean wateringEnabled;
    private Boolean fertilizerEnabled;
    private Boolean growthRecordEnabled;
    private LocalTime notificationTime;
}
