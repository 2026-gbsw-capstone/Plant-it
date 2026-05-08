package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.NotificationSetting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public interface NotificationSettingRepository extends JpaRepository<NotificationSetting, Long> {
    List<NotificationSetting> findByUserId(Long userId);
    List<NotificationSetting> findByPlantIsNotNullAndPushTokenIsNotNull();

    List<NotificationSetting> findByPlantIsNotNullAndPushTokenIsNotNullAndNotificationTime(LocalTime notificationTime);

    @Query("""
            select s
            from NotificationSetting s
            where s.plant is not null
              and s.pushToken is not null
              and s.notificationTime is null
            """)
    List<NotificationSetting> findSettingsWithEmptyNotificationTime();
    Optional<NotificationSetting> findByUserIdAndPlantId(Long userId, Long plantId);
    Optional<NotificationSetting> findFirstByUserIdAndPushTokenIsNotNull(Long userId);
}
