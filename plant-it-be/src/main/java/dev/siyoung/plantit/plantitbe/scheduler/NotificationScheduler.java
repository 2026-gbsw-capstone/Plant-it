package dev.siyoung.plantit.plantitbe.scheduler;

import dev.siyoung.plantit.plantitbe.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalTime;

@Component
@RequiredArgsConstructor
public class NotificationScheduler {
    private final NotificationService notificationService;

    @Scheduled(cron = "0 * * * * *", zone = "Asia/Seoul")
    public void sendCareNotifications() {
        notificationService.sendScheduledCareNotifications(LocalTime.now().withSecond(0).withNano(0));
    }
}
