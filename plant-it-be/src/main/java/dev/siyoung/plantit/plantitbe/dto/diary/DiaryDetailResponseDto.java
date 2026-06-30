package dev.siyoung.plantit.plantitbe.dto.diary;

import dev.siyoung.plantit.plantitbe.entity.DiaryType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DiaryDetailResponseDto {
    private Long id;
    private String imageUrl;
    private String note;
    private LocalDateTime recordedAt;
    private String aiHealthSummary;
    private DiaryType diaryType;
}
