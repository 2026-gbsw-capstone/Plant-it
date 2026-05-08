package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.diary.CreateDiaryRequestDto;
import dev.siyoung.plantit.plantitbe.dto.diary.CreateDiaryResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.DiaryDetailResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.DiaryListResponseDto;
import dev.siyoung.plantit.plantitbe.dto.diary.UpdateDiaryRequestDto;
import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.service.DiaryService;
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
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/plants/{plantId}/diaries")
public class DiaryController {
    private final DiaryService diaryService;

    @PostMapping
    public ResponseEntity<ApiResponse<CreateDiaryResponseDto>> createDiary(@AuthenticationPrincipal Long userId,
                                                                           @PathVariable Long plantId,
                                                                           @Valid @RequestBody CreateDiaryRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("성장 기록이 저장되었습니다.", diaryService.createDiary(userId, plantId, request)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<DiaryListResponseDto>>> getDiaries(@AuthenticationPrincipal Long userId,
                                                                              @PathVariable Long plantId) {
        return ResponseEntity.ok(ApiResponse.success("성장 기록 목록을 조회했습니다.", diaryService.findDiaries(userId, plantId)));
    }

    @GetMapping("/{diaryId}")
    public ResponseEntity<ApiResponse<DiaryDetailResponseDto>> getDiary(@AuthenticationPrincipal Long userId,
                                                                        @PathVariable Long plantId,
                                                                        @PathVariable Long diaryId) {
        return ResponseEntity.ok(ApiResponse.success("성장 기록 상세 정보를 조회했습니다.", diaryService.findDiary(userId, plantId, diaryId)));
    }

    @PatchMapping("/{diaryId}")
    public ResponseEntity<ApiResponse<DiaryDetailResponseDto>> updateDiary(@AuthenticationPrincipal Long userId,
                                                                           @PathVariable Long plantId,
                                                                           @PathVariable Long diaryId,
                                                                           @Valid @RequestBody UpdateDiaryRequestDto request) {
        return ResponseEntity.ok(ApiResponse.success("성장 기록이 수정되었습니다.", diaryService.updateDiary(userId, plantId, diaryId, request)));
    }

    @DeleteMapping("/{diaryId}")
    public ResponseEntity<ApiResponse<Void>> deleteDiary(@AuthenticationPrincipal Long userId,
                                                         @PathVariable Long plantId,
                                                         @PathVariable Long diaryId) {
        diaryService.deleteDiary(userId, plantId, diaryId);
        return ResponseEntity.ok(ApiResponse.success("성장 기록이 삭제되었습니다."));
    }
}
