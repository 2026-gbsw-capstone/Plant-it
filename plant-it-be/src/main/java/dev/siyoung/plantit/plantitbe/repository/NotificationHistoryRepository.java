package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.NotificationHistory;
import dev.siyoung.plantit.plantitbe.entity.NotificationHistory.NotificationType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface NotificationHistoryRepository extends JpaRepository<NotificationHistory, Long> {
    boolean existsByPlantIdAndNotificationTypeAndNotifiedDate(Long plantId, NotificationType notificationType, LocalDate notifiedDate);
    long countByUserId(Long userId);
    List<NotificationHistory> findByUserIdOrderByCreatedAtDesc(Long userId);
}
