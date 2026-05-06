package dev.siyoung.plantit.plantitbe.dto.diary;

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
    private LocalDateTime recordedAt;
}
