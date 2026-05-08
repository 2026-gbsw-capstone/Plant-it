package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideSearchRequestDto;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.PlantCareGuideRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GuideService {
    private final PlantCareGuideRepository plantCareGuideRepository;

    public List<PlantGuideListResponseDto> searchGuides(PlantGuideSearchRequestDto request) {
        return plantCareGuideRepository.search(
                        blankToNull(request.getKeyword()),
                        blankToNull(request.getDifficulty()),
                        blankToNull(request.getSunlight())
                ).stream()
                .map(EntityDtoMapper::toListDto)
                .toList();
    }

    public PlantGuideDetailResponseDto findGuide(Long guideId) {
        return EntityDtoMapper.toDto(plantCareGuideRepository.findById(guideId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "식물도감 정보를 찾을 수 없습니다.")));
    }

    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value;
    }
}
