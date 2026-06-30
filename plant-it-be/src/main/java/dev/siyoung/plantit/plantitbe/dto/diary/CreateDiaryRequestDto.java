package dev.siyoung.plantit.plantitbe.dto.diary;

import dev.siyoung.plantit.plantitbe.entity.DiaryType;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CreateDiaryRequestDto {
    private String imageUrl;
    private String note;

    @NotNull(message = "기록 시각은 필수입니다.")
    private LocalDateTime recordedAt;

    /** 성장 기록이면 true. 사진을 AI로 건강 분석하고 식물 상태를 갱신한다. */
    private boolean analyzeHealth;

    private DiaryType diaryType;

    public DiaryType resolvedDiaryType() {
        if (diaryType != null) return diaryType;
        return analyzeHealth ? DiaryType.GROWTH : DiaryType.MOMENT;
    }
}
