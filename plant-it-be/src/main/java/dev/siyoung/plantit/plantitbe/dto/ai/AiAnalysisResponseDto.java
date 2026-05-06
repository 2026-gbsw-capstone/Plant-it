package dev.siyoung.plantit.plantitbe.dto.ai;

import dev.siyoung.plantit.plantitbe.entity.PlantAiAnalysis.AnalysisType;
import dev.siyoung.plantit.plantitbe.entity.PlantAiAnalysis.ResultStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AiAnalysisResponseDto {
    private Long id;
    private Long plantId;
    private Long diaryId;
    private String imageUrl;
    private AnalysisType analysisType;
    private String resultText;
    private ResultStatus resultStatus;
    private LocalDateTime createdAt;
}
