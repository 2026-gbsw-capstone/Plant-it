package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.plant.CreatePlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.plant.CreatePlantResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.FertilizePlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.plant.PlantDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.PlantListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.UpdatePlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.plant.WaterPlantRequestDto;
import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.Plant.HealthStatus;
import dev.siyoung.plantit.plantitbe.entity.PlantCareHistory;
import dev.siyoung.plantit.plantitbe.entity.PlantCareHistory.CareType;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.PlantCareHistoryRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantRepository;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class PlantService {
    private final PlantRepository plantRepository;
    private final PlantCareHistoryRepository plantCareHistoryRepository;
    private final UserRepository userRepository;

    public CreatePlantResponseDto createPlant(Long userId, CreatePlantRequestDto request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));
        Plant plant = EntityDtoMapper.toEntity(request, user);
        return EntityDtoMapper.toCreateDto(plantRepository.save(plant));
    }

    @Transactional(readOnly = true)
    public List<PlantListResponseDto> findPlants(Long userId, String keyword, HealthStatus healthStatus) {
        return plantRepository.searchByUser(userId, blankToNull(keyword), healthStatus).stream()
                .map(EntityDtoMapper::toListDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public PlantDetailResponseDto findPlant(Long userId, Long plantId) {
        return EntityDtoMapper.toDto(findPlantEntity(userId, plantId));
    }

    public PlantDetailResponseDto updatePlant(Long userId, Long plantId, UpdatePlantRequestDto request) {
        Plant plant = findPlantEntity(userId, plantId);

        if (request.getName() != null) plant.setName(request.getName());
        if (request.getSpeciesName() != null) plant.setSpeciesName(request.getSpeciesName());
        if (request.getPlantImageUrl() != null) plant.setPlantImageUrl(request.getPlantImageUrl().isBlank() ? null : request.getPlantImageUrl());
        if (request.getWateringCycleDays() != null) plant.setWateringCycleDays(request.getWateringCycleDays());
        if (request.getFertilizerCycleDays() != null) plant.setFertilizerCycleDays(request.getFertilizerCycleDays());
        if (request.getMemo() != null) plant.setMemo(request.getMemo());

        return EntityDtoMapper.toDto(plant);
    }

    public void deletePlant(Long userId, Long plantId) {
        plantRepository.delete(findPlantEntity(userId, plantId));
    }

    public void waterPlant(Long userId, Long plantId, WaterPlantRequestDto request) {
        Plant plant = findPlantEntity(userId, plantId);
        LocalDateTime wateredAt = request.getWateredAt() == null ? LocalDateTime.now() : request.getWateredAt();
        plant.setLastWateredAt(wateredAt);
        saveCareHistory(plant, CareType.WATER, wateredAt);
    }

    public void fertilizePlant(Long userId, Long plantId, FertilizePlantRequestDto request) {
        Plant plant = findPlantEntity(userId, plantId);
        LocalDateTime fertilizedAt = request.getFertilizedAt() == null ? LocalDateTime.now() : request.getFertilizedAt();
        plant.setLastFertilizedAt(fertilizedAt);
        saveCareHistory(plant, CareType.FERTILIZER, fertilizedAt);
    }

    private Plant findPlantEntity(Long userId, Long plantId) {
        return plantRepository.findByIdAndUserId(plantId, userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "식물을 찾을 수 없습니다."));
    }

    private void saveCareHistory(Plant plant, CareType careType, LocalDateTime caredAt) {
        plantCareHistoryRepository.save(PlantCareHistory.builder()
                .plant(plant)
                .careType(careType)
                .caredAt(caredAt)
                .build());
    }

    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value;
    }
}
