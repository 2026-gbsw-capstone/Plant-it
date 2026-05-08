package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.notification.NotificationSettingResponseDto;
import dev.siyoung.plantit.plantitbe.dto.notification.NotificationHistoryResponseDto;
import dev.siyoung.plantit.plantitbe.dto.notification.RegisterPushTokenRequestDto;
import dev.siyoung.plantit.plantitbe.dto.notification.SendPushRequestDto;
import dev.siyoung.plantit.plantitbe.dto.notification.UpdateNotificationSettingRequestDto;
import dev.siyoung.plantit.plantitbe.entity.NotificationHistory;
import dev.siyoung.plantit.plantitbe.entity.NotificationHistory.NotificationType;
import dev.siyoung.plantit.plantitbe.entity.NotificationSetting;
import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.firebase.FirebaseService;
import dev.siyoung.plantit.plantitbe.repository.NotificationHistoryRepository;
import dev.siyoung.plantit.plantitbe.repository.NotificationSettingRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantRepository;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class NotificationService {
    private final NotificationSettingRepository notificationSettingRepository;
    private final NotificationHistoryRepository notificationHistoryRepository;
    private final UserRepository userRepository;
    private final PlantRepository plantRepository;
    private final FirebaseService firebaseService;

    @Transactional(readOnly = true)
    public List<NotificationSettingResponseDto> findSettings(Long userId) {
        return notificationSettingRepository.findByUserId(userId).stream()
                .map(EntityDtoMapper::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<NotificationHistoryResponseDto> findHistories(Long userId) {
        return notificationHistoryRepository.findByUserIdOrderByCreatedAtDesc(userId).stream()
                .map(EntityDtoMapper::toDto)
                .toList();
    }

    public NotificationSettingResponseDto updateSetting(Long userId, UpdateNotificationSettingRequestDto request) {
        User user = findUser(userId);
        Plant plant = plantRepository.findByIdAndUserId(request.getPlantId(), userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "식물을 찾을 수 없습니다."));
        NotificationSetting setting = notificationSettingRepository.findByUserIdAndPlantId(userId, request.getPlantId())
                .orElseGet(() -> NotificationSetting.builder()
                        .user(user)
                        .plant(plant)
                        .pushToken(findUserPushToken(userId).orElse(null))
                        .build());

        if (request.getWateringEnabled() != null) setting.setWateringEnabled(request.getWateringEnabled());
        if (request.getFertilizerEnabled() != null) setting.setFertilizerEnabled(request.getFertilizerEnabled());
        if (request.getGrowthRecordEnabled() != null) setting.setGrowthRecordEnabled(request.getGrowthRecordEnabled());
        if (request.getNotificationTime() != null) setting.setNotificationTime(request.getNotificationTime().withSecond(0).withNano(0));

        return EntityDtoMapper.toDto(notificationSettingRepository.save(setting));
    }

    public void registerPushToken(Long userId, RegisterPushTokenRequestDto request) {
        User user = findUser(userId);
        List<NotificationSetting> settings = notificationSettingRepository.findByUserId(userId);

        if (settings.isEmpty()) {
            notificationSettingRepository.save(NotificationSetting.builder()
                    .user(user)
                    .pushToken(request.getPushToken())
                    .build());
            return;
        }

        settings.forEach(setting -> setting.setPushToken(request.getPushToken()));
    }

    public String sendPush(Long userId, SendPushRequestDto request) {
        return sendPush(userId, request.getPlantId(), request.getTitle(), request.getBody());
    }

    public void sendScheduledCareNotifications(LocalTime notificationTime) {
        LocalTime normalizedTime = notificationTime.withSecond(0).withNano(0);
        notificationSettingRepository.findByPlantIsNotNullAndPushTokenIsNotNullAndNotificationTime(normalizedTime)
                .forEach(this::sendCareNotificationIfNeeded);

        if (normalizedTime.equals(LocalTime.of(9, 0))) {
            notificationSettingRepository.findSettingsWithEmptyNotificationTime()
                    .forEach(this::sendCareNotificationIfNeeded);
        }
    }

    private String sendPush(Long userId, Long plantId, String title, String body) {
        NotificationSetting setting = notificationSettingRepository.findByUserIdAndPlantId(userId, plantId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "알림 설정을 찾을 수 없습니다."));

        if (setting.getPushToken() == null || setting.getPushToken().isBlank()) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "등록된 푸시 토큰이 없습니다.");
        }

        return firebaseService.sendPush(setting.getPushToken(), title, body);
    }

    private void sendCareNotificationIfNeeded(NotificationSetting setting) {
        Plant plant = setting.getPlant();
        User user = setting.getUser();
        LocalDate today = LocalDate.now();

        if (Boolean.TRUE.equals(setting.getWateringEnabled())
                && isWateringDue(plant, today)
                && hasNotSentToday(plant.getId(), NotificationType.WATERING, today)) {
            String messageId = firebaseService.sendPush(
                    setting.getPushToken(),
                    "물 줄 시간이에요",
                    plant.getName() + "에게 물을 줄 때가 되었어요."
            );
            saveHistory(user, plant, NotificationType.WATERING, today, messageId);
        }

        if (Boolean.TRUE.equals(setting.getFertilizerEnabled())
                && isFertilizerDue(plant, today)
                && hasNotSentToday(plant.getId(), NotificationType.FERTILIZER, today)) {
            String messageId = firebaseService.sendPush(
                    setting.getPushToken(),
                    "비료 줄 시간이에요",
                    plant.getName() + "에게 비료를 줄 때가 되었어요."
            );
            saveHistory(user, plant, NotificationType.FERTILIZER, today, messageId);
        }
    }

    private boolean isWateringDue(Plant plant, LocalDate today) {
        if (plant.getWateringCycleDays() == null) {
            return false;
        }

        LocalDateTime baseDateTime = plant.getLastWateredAt() == null
                ? plant.getRegisteredAt()
                : plant.getLastWateredAt();

        return isDue(baseDateTime, plant.getWateringCycleDays(), today);
    }

    private boolean isFertilizerDue(Plant plant, LocalDate today) {
        if (plant.getFertilizerCycleDays() == null) {
            return false;
        }

        LocalDateTime baseDateTime = plant.getLastFertilizedAt() == null
                ? plant.getRegisteredAt()
                : plant.getLastFertilizedAt();

        return isDue(baseDateTime, plant.getFertilizerCycleDays(), today);
    }

    private boolean isDue(LocalDateTime baseDateTime, Integer cycleDays, LocalDate today) {
        return baseDateTime != null && !baseDateTime.toLocalDate().plusDays(cycleDays).isAfter(today);
    }

    private boolean hasNotSentToday(Long plantId, NotificationType notificationType, LocalDate today) {
        return !notificationHistoryRepository.existsByPlantIdAndNotificationTypeAndNotifiedDate(
                plantId,
                notificationType,
                today
        );
    }

    private void saveHistory(User user, Plant plant, NotificationType notificationType, LocalDate today, String messageId) {
        notificationHistoryRepository.save(NotificationHistory.builder()
                .user(user)
                .plant(plant)
                .notificationType(notificationType)
                .notifiedDate(today)
                .messageId(messageId)
                .build());
    }

    private Optional<String> findUserPushToken(Long userId) {
        return notificationSettingRepository.findFirstByUserIdAndPushTokenIsNotNull(userId)
                .map(NotificationSetting::getPushToken);
    }

    private User findUser(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));
    }
}
