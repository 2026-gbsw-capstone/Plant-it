package dev.siyoung.plantit.plantitbe.dto.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlantCareGuideFormDto {
    @NotBlank(message = "식물 종 이름은 필수입니다.")
    @Size(max = 100, message = "식물 종 이름은 100자 이하여야 합니다.")
    private String speciesName;

    @NotBlank(message = "난이도는 필수입니다.")
    @Size(max = 20, message = "난이도는 20자 이하여야 합니다.")
    private String difficulty;

    @NotBlank(message = "일조 정보는 필수입니다.")
    private String sunlight;

    @NotBlank(message = "물주기 정보는 필수입니다.")
    private String watering;

    private String fertilizer;
    private String humidity;
    private String temperature;
    private String toxicity;
    private String description;
    private String imageUrl;

    public String getSpeciesName() {
        return valueOrEmpty(speciesName);
    }

    public String getDifficulty() {
        return valueOrEmpty(difficulty);
    }

    public String getSunlight() {
        return valueOrEmpty(sunlight);
    }

    public String getWatering() {
        return valueOrEmpty(watering);
    }

    public String getFertilizer() {
        return valueOrEmpty(fertilizer);
    }

    public String getHumidity() {
        return valueOrEmpty(humidity);
    }

    public String getTemperature() {
        return valueOrEmpty(temperature);
    }

    public String getToxicity() {
        return valueOrEmpty(toxicity);
    }

    public String getDescription() {
        return valueOrEmpty(description);
    }

    public String getImageUrl() {
        return valueOrEmpty(imageUrl);
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }
}
