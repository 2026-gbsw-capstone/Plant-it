package dev.siyoung.plantit.plantitbe.dto.notification;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateNotificationSettingRequestDto {
    private Long plantId;
    private Boolean wateringEnabled;
    private Boolean fertilizerEnabled;
    private Boolean growthRecordEnabled;
}
