package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideSearchRequestDto;
import dev.siyoung.plantit.plantitbe.entity.PlantCareGuide;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.PlantCareGuideRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GuideService {
    private final PlantCareGuideRepository plantCareGuideRepository;
    private final ImageUploadService imageUploadService;

    public List<PlantGuideListResponseDto> searchGuides(PlantGuideSearchRequestDto request) {
        return plantCareGuideRepository.search(
                        blankToNull(request.getKeyword()),
                        blankToNull(request.getSunlight())
                ).stream()
                .map(EntityDtoMapper::toListDto)
                .toList();
    }

    public PlantGuideDetailResponseDto findGuide(Long guideId) {
        return EntityDtoMapper.toDto(findGuideEntity(guideId));
    }

    @Transactional
    public PlantGuideDetailResponseDto updateDefaultImage(Long guideId, MultipartFile image) {
        PlantCareGuide guide = findGuideEntity(guideId);
        guide.setImageUrl(imageUploadService.uploadImage(image, "guide").getImageUrl());
        return EntityDtoMapper.toDto(guide);
    }

    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value;
    }

    private PlantCareGuide findGuideEntity(Long guideId) {
        return plantCareGuideRepository.findById(guideId)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "식물도감 정보를 찾을 수 없습니다."));
    }
}
