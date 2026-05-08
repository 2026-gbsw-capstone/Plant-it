package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.common.ApiResponse;
import dev.siyoung.plantit.plantitbe.dto.upload.ImageUploadResponseDto;
import dev.siyoung.plantit.plantitbe.service.ImageUploadService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/uploads")
public class ImageUploadController {
    private final ImageUploadService imageUploadService;

    @Operation(summary = "이미지 업로드", description = "이미지를 업로드하고 앱에서 사용할 URL을 반환합니다. type은 plant, diary, ai, guide를 사용할 수 있습니다.")
    @PostMapping("/images")
    public ResponseEntity<ApiResponse<ImageUploadResponseDto>> uploadImage(@RequestParam MultipartFile file,
                                                                           @RequestParam(required = false) String type) {
        return ResponseEntity.ok(ApiResponse.success("이미지가 업로드되었습니다.", imageUploadService.uploadImage(file, type)));
    }
}
