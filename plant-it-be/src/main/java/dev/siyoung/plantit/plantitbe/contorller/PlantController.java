package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.ai.AiAnalysisResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.CreatePlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.plant.CreatePlantResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.FertilizePlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.plant.PlantDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.PlantListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.plant.UpdatePlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.plant.WaterPlantRequestDto;
import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.entity.Plant.HealthStatus;
import dev.siyoung.plantit.plantitbe.service.AiService;
import dev.siyoung.plantit.plantitbe.service.PlantService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/plants")
public class PlantController {
    private final PlantService plantService;
    private final AiService aiService;

    @Operation(summary = "식물 등록", description = "JWT 사용자 기준으로 식물을 등록합니다.")
    @PostMapping
    public ResponseEntity<ApiResponse<CreatePlantResponseDto>> createPlant(@AuthenticationPrincipal Long userId,
                                                                           @Valid @RequestBody CreatePlantRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("식물이 등록되었습니다.", plantService.createPlant(userId, request)));
    }

    @Operation(summary = "식물 목록 조회", description = "JWT 사용자 기준으로 식물을 조회합니다. keyword와 healthStatus로 검색할 수 있습니다.")
    @GetMapping
    public ResponseEntity<ApiResponse<List<PlantListResponseDto>>> getPlants(@AuthenticationPrincipal Long userId,
                                                                             @RequestParam(required = false) String keyword,
                                                                             @RequestParam(required = false) HealthStatus healthStatus) {
        return ResponseEntity.ok(ApiResponse.success("식물 목록을 조회했습니다.", plantService.findPlants(userId, keyword, healthStatus)));
    }

    @GetMapping("/{plantId}")
    public ResponseEntity<ApiResponse<PlantDetailResponseDto>> getPlant(@AuthenticationPrincipal Long userId,
                                                                        @PathVariable Long plantId) {
        return ResponseEntity.ok(ApiResponse.success("식물 상세 정보를 조회했습니다.", plantService.findPlant(userId, plantId)));
    }

    @PatchMapping("/{plantId}")
    public ResponseEntity<ApiResponse<PlantDetailResponseDto>> updatePlant(@AuthenticationPrincipal Long userId,
                                                                           @PathVariable Long plantId,
                                                                           @Valid @RequestBody UpdatePlantRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("식물 정보가 수정되었습니다.", plantService.updatePlant(userId, plantId, request)));
    }

    @DeleteMapping("/{plantId}")
    public ResponseEntity<ApiResponse<Void>> deletePlant(@AuthenticationPrincipal Long userId, @PathVariable Long plantId) {
        plantService.deletePlant(userId, plantId);
        return ResponseEntity.ok(ApiResponse.success("식물이 삭제되었습니다."));
    }

    @PostMapping("/{plantId}/water")
    public ResponseEntity<ApiResponse<Void>> waterPlant(@AuthenticationPrincipal Long userId,
                                                        @PathVariable Long plantId,
                                                        @Valid @RequestBody WaterPlantRequestDto request) {
        plantService.waterPlant(userId, plantId, request);
        return ResponseEntity.ok(ApiResponse.success("물주기 기록이 저장되었습니다."));
    }

    @PostMapping("/{plantId}/fertilizer")
    public ResponseEntity<ApiResponse<Void>> fertilizePlant(@AuthenticationPrincipal Long userId,
                                                            @PathVariable Long plantId,
                                                            @Valid @RequestBody FertilizePlantRequestDto request) {
        plantService.fertilizePlant(userId, plantId, request);
        return ResponseEntity.ok(ApiResponse.success("비료주기 기록이 저장되었습니다."));
    }

    @GetMapping("/{plantId}/ai-analyses")
    public ResponseEntity<ApiResponse<List<AiAnalysisResponseDto>>> getAiAnalyses(@AuthenticationPrincipal Long userId,
                                                                                  @PathVariable Long plantId) {
        return ResponseEntity.ok(ApiResponse.success("AI 분석 이력을 조회했습니다.", aiService.findAnalyses(userId, plantId)));
    }
}
