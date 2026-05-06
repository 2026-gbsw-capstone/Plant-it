package dev.siyoung.plantit.plantitbe.dto.plant;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class FertilizePlantRequestDto {
    private LocalDateTime fertilizedAt;
}
