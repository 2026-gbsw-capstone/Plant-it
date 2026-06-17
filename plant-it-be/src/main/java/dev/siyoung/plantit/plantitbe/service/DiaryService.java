package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.diary.CreateDiaryRequestDto;
import dev.siyoung.plantit.plantitbe.dto.diary.CreateDiaryResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.DiaryDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.DiaryListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.UpdateDiaryRequestDto;
import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.PlantDiary;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.PlantDiaryRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantRepository;
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
public class DiaryService {
    private final PlantRepository plantRepository;
    private final PlantDiaryRepository plantDiaryRepository;

    public CreateDiaryResponseDto createDiary(Long userId, Long plantId, CreateDiaryRequestDto request) {
        Plant plant = plantRepository.findByIdAndUserId(plantId, userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "식물을 찾을 수 없습니다."));
        PlantDiary diary = EntityDtoMapper.toEntity(request, plant);
        if (diary.getRecordedAt() == null) {
            diary.setRecordedAt(LocalDateTime.now());
        }
        return EntityDtoMapper.toCreateDto(plantDiaryRepository.save(diary));
    }

    @Transactional(readOnly = true)
    public List<DiaryListResponseDto> findDiaries(Long userId, Long plantId) {
        return plantDiaryRepository.findByPlantIdAndPlantUserIdOrderByRecordedAtAsc(plantId, userId).stream()
                .map(EntityDtoMapper::toListDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public DiaryDetailResponseDto findDiary(Long userId, Long plantId, Long diaryId) {
        return EntityDtoMapper.toDto(findDiaryEntity(userId, plantId, diaryId));
    }

    public DiaryDetailResponseDto updateDiary(Long userId, Long plantId, Long diaryId, UpdateDiaryRequestDto request) {
        PlantDiary diary = findDiaryEntity(userId, plantId, diaryId);

        if (request.getImageUrl() != null) diary.setImageUrl(request.getImageUrl());
        if (request.getNote() != null) diary.setNote(request.getNote());
        if (request.getRecordedAt() != null) diary.setRecordedAt(request.getRecordedAt());

        return EntityDtoMapper.toDto(diary);
    }

    public void deleteDiary(Long userId, Long plantId, Long diaryId) {
        PlantDiary diary = findDiaryEntity(userId, plantId, diaryId);
        plantDiaryRepository.delete(diary);
    }

    private PlantDiary findDiaryEntity(Long userId, Long plantId, Long diaryId) {
        return plantDiaryRepository.findByIdAndPlantIdAndPlantUserId(diaryId, plantId, userId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "성장 기록을 찾을 수 없습니다."));
    }
}
