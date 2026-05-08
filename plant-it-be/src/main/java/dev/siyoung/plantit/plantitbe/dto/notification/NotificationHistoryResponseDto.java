package dev.siyoung.plantit.plantitbe.dto.notification;

import dev.siyoung.plantit.plantitbe.entity.NotificationHistory.NotificationType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationHistoryResponseDto {
    private Long id;
    private Long plantId;
    private String plantName;
    private NotificationType notificationType;
    private LocalDate notifiedDate;
    private LocalDateTime createdAt;
}
