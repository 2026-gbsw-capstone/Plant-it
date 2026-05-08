package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.admin.PlantCareGuideFormDto;
import dev.siyoung.plantit.plantitbe.entity.PlantCareGuide;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.PlantCareGuideRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminPlantCareGuideService {
    private final PlantCareGuideRepository plantCareGuideRepository;

    @Transactional(readOnly = true)
    public List<PlantCareGuide> findAll() {
        return plantCareGuideRepository.findAll();
    }

    @Transactional(readOnly = true)
    public PlantCareGuide findById(Long id) {
        return plantCareGuideRepository.findById(id)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "식물도감 정보를 찾을 수 없습니다."));
    }

    public PlantCareGuide create(PlantCareGuideFormDto form) {
        PlantCareGuide guide = PlantCareGuide.builder().build();
        applyForm(guide, form);
        return plantCareGuideRepository.save(guide);
    }

    public void update(Long id, PlantCareGuideFormDto form) {
        PlantCareGuide guide = findById(id);
        applyForm(guide, form);
    }

    public void delete(Long id) {
        plantCareGuideRepository.delete(findById(id));
    }

    public PlantCareGuideFormDto toForm(PlantCareGuide guide) {
        return PlantCareGuideFormDto.builder()
                .speciesName(guide.getSpeciesName())
                .difficulty(guide.getDifficulty())
                .sunlight(guide.getSunlight())
                .watering(guide.getWatering())
                .fertilizer(guide.getFertilizer())
                .humidity(guide.getHumidity())
                .temperature(guide.getTemperature())
                .toxicity(guide.getToxicity())
                .description(guide.getDescription())
                .imageUrl(guide.getImageUrl())
                .build();
    }

    private void applyForm(PlantCareGuide guide, PlantCareGuideFormDto form) {
        guide.setSpeciesName(form.getSpeciesName());
        guide.setDifficulty(form.getDifficulty());
        guide.setSunlight(form.getSunlight());
        guide.setWatering(form.getWatering());
        guide.setFertilizer(form.getFertilizer());
        guide.setHumidity(form.getHumidity());
        guide.setTemperature(form.getTemperature());
        guide.setToxicity(form.getToxicity());
        guide.setDescription(form.getDescription());
        guide.setImageUrl(form.getImageUrl());
    }
}
