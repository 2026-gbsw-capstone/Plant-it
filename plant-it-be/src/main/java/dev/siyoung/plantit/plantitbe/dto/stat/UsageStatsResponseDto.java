package dev.siyoung.plantit.plantitbe.dto.stat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsageStatsResponseDto {
    private long notificationReceivedCount;
    private long wateringCount;
    private long diaryCount;
    private long appTogetherDays;
    private String oldestPlantName;
    private long oldestPlantTogetherDays;
}
