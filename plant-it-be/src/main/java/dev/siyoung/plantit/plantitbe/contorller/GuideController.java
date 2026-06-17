package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.guide.PlantGuideSearchRequestDto;
import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.service.GuideService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/guide/plants")
public class GuideController {
    private final GuideService guideService;

    @Operation(summary = "식물도감 검색", description = "키워드, 일조 조건으로 식물도감을 검색합니다.")
    @GetMapping
    public ResponseEntity<ApiResponse<List<PlantGuideListResponseDto>>> getGuides(@RequestParam(required = false) String keyword,
                                                                                  @RequestParam(required = false) String sunlight) {
        PlantGuideSearchRequestDto request = new PlantGuideSearchRequestDto(keyword, sunlight);
        return ResponseEntity.ok(ApiResponse.success("식물도감 목록을 조회했습니다.", guideService.searchGuides(request)));
    }

    @Operation(summary = "식물도감 상세 조회", description = "식물도감 상세 정보를 조회합니다.")
    @GetMapping("/{guideId}")
    public ResponseEntity<ApiResponse<PlantGuideDetailResponseDto>> getGuide(@PathVariable Long guideId) {
        return ResponseEntity.ok(ApiResponse.success("식물도감 상세 정보를 조회했습니다.", guideService.findGuide(guideId)));
    }

    @Operation(summary = "식물별 기본 이미지 등록", description = "이미지 파일을 업로드해서 식물도감 항목의 기본 이미지로 등록합니다.")
    @PatchMapping(value = "/{guideId}/default-image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ApiResponse<PlantGuideDetailResponseDto>> updateDefaultImage(@PathVariable Long guideId,
                                                                                       @RequestParam MultipartFile image) {
        return ResponseEntity.ok(ApiResponse.success("식물 기본 이미지가 저장되었습니다.", guideService.updateDefaultImage(guideId, image)));
    }
}
