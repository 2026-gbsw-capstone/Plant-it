package dev.siyoung.plantit.plantitbe.utils;

import dev.siyoung.plantit.plantitbe.dto.ai.AiAnalysisResponseDto;
import dev.siyoung.plantit.plantitbe.dto.auth.SignupResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.CreateDiaryRequestDto;
import dev.siyoung.plantit.plantitbe.dto.diary.CreateDiaryResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.DiaryDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.DiaryListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.notification.NotificationHistoryResponseDto;
import dev.siyoung.plantit.plantitbe.dto.notification.NotificationSettingResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.CreatePlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.plant.CreatePlantResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.PlantDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.PlantListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.user.MeResponseDto;
import dev.siyoung.plantit.plantitbe.entity.NotificationSetting;
import dev.siyoung.plantit.plantitbe.entity.NotificationHistory;
import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.PlantAiAnalysis;
import dev.siyoung.plantit.plantitbe.entity.PlantCareGuide;
import dev.siyoung.plantit.plantitbe.entity.PlantDiary;
import dev.siyoung.plantit.plantitbe.entity.User;

import java.time.LocalDate;
import java.time.LocalDateTime;

public final class EntityDtoMapper {

    private EntityDtoMapper() {
    }

    public static MeResponseDto toDto(User user) {
        return MeResponseDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .profileImageUrl(user.getProfileImageUrl())
                .build();
    }

    public static PlantDetailResponseDto toDto(Plant plant) {
        return PlantDetailResponseDto.builder()
                .id(plant.getId())
                .name(plant.getName())
                .speciesName(plant.getSpeciesName())
                .plantImageUrl(plant.getPlantImageUrl())
                .wateringCycleDays(plant.getWateringCycleDays())
                .fertilizerCycleDays(plant.getFertilizerCycleDays())
                .lastWateredAt(plant.getLastWateredAt())
                .lastFertilizedAt(plant.getLastFertilizedAt())
                .nextWateringDate(calculateNextWateringDate(plant))
                .healthStatus(plant.getHealthStatus())
                .memo(plant.getMemo())
                .build();
    }

    public static DiaryDetailResponseDto toDto(PlantDiary diary) {
        return DiaryDetailResponseDto.builder()
                .id(diary.getId())
                .imageUrl(diary.getImageUrl())
                .note(diary.getNote())
                .recordedAt(diary.getRecordedAt())
                .aiHealthSummary(diary.getAiHealthSummary())
                .build();
    }

    public static AiAnalysisResponseDto toDto(PlantAiAnalysis analysis) {
        return AiAnalysisResponseDto.builder()
                .id(analysis.getId())
                .plantId(analysis.getPlant().getId())
                .diaryId(analysis.getDiary() == null ? null : analysis.getDiary().getId())
                .imageUrl(analysis.getImageUrl())
                .analysisType(analysis.getAnalysisType())
                .resultText(analysis.getResultText())
                .resultStatus(analysis.getResultStatus())
                .createdAt(analysis.getCreatedAt())
                .build();
    }

    public static NotificationSettingResponseDto toDto(NotificationSetting setting) {
        return NotificationSettingResponseDto.builder()
                .plantId(setting.getPlant() == null ? null : setting.getPlant().getId())
                .wateringEnabled(setting.getWateringEnabled())
                .fertilizerEnabled(setting.getFertilizerEnabled())
                .growthRecordEnabled(setting.getGrowthRecordEnabled())
                .notificationTime(setting.getNotificationTime())
                .build();
    }

    public static NotificationHistoryResponseDto toDto(NotificationHistory history) {
        return NotificationHistoryResponseDto.builder()
                .id(history.getId())
                .plantId(history.getPlant().getId())
                .plantName(history.getPlant().getName())
                .notificationType(history.getNotificationType())
                .notifiedDate(history.getNotifiedDate())
                .createdAt(history.getCreatedAt())
                .build();
    }

    public static PlantGuideDetailResponseDto toDto(PlantCareGuide guide) {
        return PlantGuideDetailResponseDto.builder()
                .id(guide.getId())
                .speciesName(guide.getSpeciesName())
                .size(guide.getSize())
                .lifespan(guide.getLifespan())
                .sunlight(guide.getSunlight())
                .watering(guide.getWatering())
                .fertilizer(guide.getFertilizer())
                .humidity(guide.getHumidity())
                .temperature(guide.getTemperature())
                .toxicity(guide.getToxicity())
                .description(guide.getDescription())
                .imageUrl(guide.getImageUrl())
                .build();
    }

    public static SignupResponseDto toSignupDto(User user) {
        return SignupResponseDto.builder()
                .userId(user.getId())
                .build();
    }

    public static CreatePlantResponseDto toCreateDto(Plant plant) {
        return CreatePlantResponseDto.builder()
                .plantId(plant.getId())
                .build();
    }

    public static PlantListResponseDto toListDto(Plant plant) {
        return PlantListResponseDto.builder()
                .id(plant.getId())
                .name(plant.getName())
                .speciesName(plant.getSpeciesName())
                .plantImageUrl(plant.getPlantImageUrl())
                .healthStatus(plant.getHealthStatus())
                .nextWateringDate(calculateNextWateringDate(plant))
                .build();
    }

    public static CreateDiaryResponseDto toCreateDto(PlantDiary diary) {
        return CreateDiaryResponseDto.builder()
                .diaryId(diary.getId())
                .build();
    }

    public static DiaryListResponseDto toListDto(PlantDiary diary) {
        return DiaryListResponseDto.builder()
                .id(diary.getId())
                .imageUrl(diary.getImageUrl())
                .note(diary.getNote())
                .recordedAt(diary.getRecordedAt())
                .aiHealthSummary(diary.getAiHealthSummary())
                .build();
    }

    public static PlantGuideListResponseDto toListDto(PlantCareGuide guide) {
        return PlantGuideListResponseDto.builder()
                .id(guide.getId())
                .speciesName(guide.getSpeciesName())
                .imageUrl(guide.getImageUrl())
                .build();
    }

    public static Plant toEntity(CreatePlantRequestDto request, User user) {
        return Plant.builder()
                .id(null)
                .user(user)
                .name(request.getName())
                .speciesName(request.getSpeciesName())
                .plantImageUrl(request.getPlantImageUrl())
                .registeredAt(LocalDateTime.now())
                .lastWateredAt(null)
                .lastFertilizedAt(null)
                .wateringCycleDays(request.getWateringCycleDays())
                .fertilizerCycleDays(request.getFertilizerCycleDays())
                .memo(request.getMemo())
                .createdAt(null)
                .updatedAt(null)
                .build();
    }

    public static PlantDiary toEntity(CreateDiaryRequestDto request, Plant plant) {
        return PlantDiary.builder()
                .id(null)
                .plant(plant)
                .imageUrl(request.getImageUrl())
                .note(request.getNote())
                .recordedAt(request.getRecordedAt())
                .aiHealthSummary(null)
                .createdAt(null)
                .updatedAt(null)
                .build();
    }

    private static LocalDate calculateNextWateringDate(Plant plant) {
        if (plant.getWateringCycleDays() == null) {
            return null;
        }

        LocalDateTime baseDateTime = plant.getLastWateredAt() == null
                ? plant.getRegisteredAt()
                : plant.getLastWateredAt();

        if (baseDateTime == null) {
            return null;
        }

        return baseDateTime.toLocalDate().plusDays(plant.getWateringCycleDays());
    }
}
