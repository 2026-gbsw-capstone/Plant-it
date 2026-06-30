package dev.siyoung.plantit.plantitbe.scheduler;

import dev.siyoung.plantit.plantitbe.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalTime;
import java.util.concurrent.atomic.AtomicBoolean;

@Component
@RequiredArgsConstructor
public class NotificationScheduler {
    private final NotificationService notificationService;
    private final AtomicBoolean ready = new AtomicBoolean(false);

    @EventListener(ApplicationReadyEvent.class)
    public void onReady() {
        ready.set(true);
    }

    @Scheduled(cron = "0 * * * * *", zone = "Asia/Seoul")
    public void sendCareNotifications() {
        if (!ready.get()) return;
        notificationService.sendScheduledCareNotifications(LocalTime.now().withSecond(0).withNano(0));
    }
}
