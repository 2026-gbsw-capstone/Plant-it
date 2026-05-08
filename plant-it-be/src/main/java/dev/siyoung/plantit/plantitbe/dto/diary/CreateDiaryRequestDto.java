package dev.siyoung.plantit.plantitbe.dto.diary;

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
}
