package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.upload.ImageUploadResponseDto;
import dev.siyoung.plantit.plantitbe.firebase.FirebaseService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class ImageUploadService {
    private final FirebaseService firebaseService;
    private final AwsCliStorageService awsCliStorageService;

    @Value("${storage.provider:firebase}")
    private String storageProvider;

    public ImageUploadResponseDto uploadImage(MultipartFile file, String type) {
        String directory = switch (type == null ? "" : type) {
            case "plant" -> "plants";
            case "diary" -> "diaries";
            case "ai" -> "ai";
            case "guide" -> "guides";
            default -> "images";
        };

        String imageUrl = "aws-cli".equalsIgnoreCase(storageProvider)
                ? awsCliStorageService.uploadImage(file, directory)
                : firebaseService.uploadImage(file, directory);

        return ImageUploadResponseDto.builder()
                .imageUrl(imageUrl)
                .build();
    }
}
