package dev.siyoung.plantit.plantitbe.dto.diary;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateDiaryResponseDto {
    private Long diaryId;
}
