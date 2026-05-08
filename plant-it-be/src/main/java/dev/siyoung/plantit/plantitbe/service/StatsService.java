package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.stat.UsageStatsResponseDto;
import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.PlantCareHistory.CareType;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.NotificationHistoryRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantCareHistoryRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantDiaryRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantRepository;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StatsService {
    private final UserRepository userRepository;
    private final PlantRepository plantRepository;
    private final PlantDiaryRepository plantDiaryRepository;
    private final PlantCareHistoryRepository plantCareHistoryRepository;
    private final NotificationHistoryRepository notificationHistoryRepository;

    public UsageStatsResponseDto findUsageStats(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));
        Plant oldestPlant = plantRepository.findTopByUserIdOrderByRegisteredAtAsc(userId).orElse(null);

        return UsageStatsResponseDto.builder()
                .notificationReceivedCount(notificationHistoryRepository.countByUserId(userId))
                .wateringCount(plantCareHistoryRepository.countByPlantUserIdAndCareType(userId, CareType.WATER))
                .diaryCount(plantDiaryRepository.countByPlantUserId(userId))
                .appTogetherDays(calculateTogetherDays(user.getCreatedAt()))
                .oldestPlantName(oldestPlant == null ? null : oldestPlant.getName())
                .oldestPlantTogetherDays(oldestPlant == null ? 0 : calculateTogetherDays(oldestPlant.getRegisteredAt()))
                .build();
    }

    private long calculateTogetherDays(LocalDateTime startedAt) {
        if (startedAt == null) {
            return 0;
        }

        long days = ChronoUnit.DAYS.between(startedAt.toLocalDate(), LocalDate.now()) + 1;
        return Math.max(days, 1);
    }
}
