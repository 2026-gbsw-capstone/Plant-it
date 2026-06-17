package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@Service
public class AwsCliStorageService {
    private final String bucket;
    private final String publicUrlBase;
    private final String region;

    public AwsCliStorageService(@Value("${aws.s3.bucket:}") String bucket,
                                @Value("${aws.s3.public-url-base:}") String publicUrlBase,
                                @Value("${aws.s3.region:ap-northeast-2}") String region) {
        this.bucket = bucket;
        this.publicUrlBase = publicUrlBase;
        this.region = region;
    }

    public String uploadImage(MultipartFile file, String directory) {
        validate(file);
        requireBucket();

        String objectName = objectName(directory, file.getOriginalFilename());
        Path tempFile = null;

        try {
            tempFile = Files.createTempFile("plant-it-upload-", getExtension(file.getOriginalFilename()));
            file.transferTo(tempFile);

            Process process = new ProcessBuilder(
                    "aws",
                    "s3",
                    "cp",
                    tempFile.toString(),
                    "s3://" + bucket + "/" + objectName,
                    "--content-type",
                    file.getContentType()
            ).redirectErrorStream(true).start();

            String output = new String(process.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                System.err.println("AWS CLI Error: " + output);
                throw new PlantItException(HttpStatus.BAD_GATEWAY, "S3 업로드 실패: " + output);
            }

            return publicUrl(objectName);
        } catch (PlantItException e) {
            throw e;
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "S3 업로드에 실패했습니다.");
        } finally {
            if (tempFile != null) {
                try {
                    Files.deleteIfExists(tempFile);
                } catch (Exception ignored) {
                }
            }
        }
    }

    private void validate(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "업로드할 이미지가 필요합니다.");
        }
        if (file.getContentType() == null || !file.getContentType().startsWith("image/")) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "이미지 파일만 업로드할 수 있습니다.");
        }
    }

    private void requireBucket() {
        if (!hasText(bucket)) {
            throw new PlantItException(HttpStatus.SERVICE_UNAVAILABLE, "S3 버킷 설정이 필요합니다.");
        }
    }

    private String objectName(String directory, String filename) {
        String safeDirectory = hasText(directory) ? directory : "images";
        return safeDirectory + "/" + UUID.randomUUID() + getExtension(filename);
    }

    private String getExtension(String filename) {
        if (!hasText(filename) || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf("."));
    }

    private String publicUrl(String objectName) {
        if (hasText(publicUrlBase)) {
            return publicUrlBase.replaceAll("/$", "") + "/" + objectName;
        }

        String encodedName = URLEncoder.encode(objectName, StandardCharsets.UTF_8).replace("+", "%20");
        return "https://" + bucket + ".s3." + region + ".amazonaws.com/" + encodedName;
    }

    private boolean hasText(String value) {
        return value != null && !value.isBlank();
    }
}
