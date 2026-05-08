package dev.siyoung.plantit.plantitbe.firebase;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.google.firebase.cloud.StorageClient;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.google.cloud.storage.BlobInfo;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;
import java.util.UUID;

@Service
public class FirebaseService {
    private final String credentialsPath;
    private final String credentialsJson;
    private final String credentialsBase64;
    private final String projectId;
    private final String storageBucket;

    private FirebaseApp firebaseApp;

    public FirebaseService(@Value("${firebase.credentials.path:}") String credentialsPath,
                           @Value("${firebase.credentials.json:}") String credentialsJson,
                           @Value("${firebase.credentials.base64:}") String credentialsBase64,
                           @Value("${firebase.project-id:}") String projectId,
                           @Value("${firebase.storage-bucket:}") String storageBucket) {
        this.credentialsPath = credentialsPath;
        this.credentialsJson = credentialsJson;
        this.credentialsBase64 = credentialsBase64;
        this.projectId = projectId;
        this.storageBucket = storageBucket;
    }

    @PostConstruct
    public void initialize() {
        if (!hasText(credentialsPath) && !hasText(credentialsJson) && !hasText(credentialsBase64)) {
            return;
        }

        try (InputStream credentials = credentialsInputStream()) {
            FirebaseOptions.Builder options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(credentials));

            if (hasText(projectId)) {
                options.setProjectId(projectId);
            }
            if (hasText(storageBucket)) {
                options.setStorageBucket(storageBucket);
            }

            firebaseApp = FirebaseApp.getApps().isEmpty()
                    ? FirebaseApp.initializeApp(options.build())
                    : FirebaseApp.getInstance();
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.INTERNAL_SERVER_ERROR, "Firebase 초기화에 실패했습니다.");
        }
    }

    public FirebaseUserInfo verifyIdToken(String idToken) {
        FirebaseToken token = verifyToken(idToken);
        return FirebaseUserInfo.builder()
                .uid(token.getUid())
                .email(token.getEmail())
                .name(token.getName())
                .picture(token.getPicture())
                .build();
    }

    public String sendPush(String pushToken, String title, String body) {
        requireFirebase();

        try {
            Message message = Message.builder()
                    .setToken(pushToken)
                    .setNotification(Notification.builder()
                            .setTitle(title)
                            .setBody(body)
                            .build())
                    .build();

            return FirebaseMessaging.getInstance(firebaseApp).send(message);
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "푸시 알림 발송에 실패했습니다.");
        }
    }

    public String uploadImage(MultipartFile file, String directory) {
        requireFirebase();
        requireStorageBucket();

        if (file == null || file.isEmpty()) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "업로드할 이미지가 필요합니다.");
        }
        if (file.getContentType() == null || !file.getContentType().startsWith("image/")) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "이미지 파일만 업로드할 수 있습니다.");
        }

        String safeDirectory = hasText(directory) ? directory : "images";
        String extension = getExtension(file.getOriginalFilename());
        String objectName = safeDirectory + "/" + UUID.randomUUID() + extension;
        String downloadToken = UUID.randomUUID().toString();

        try {
            BlobInfo blobInfo = BlobInfo.newBuilder(storageBucket, objectName)
                    .setContentType(file.getContentType())
                    .setMetadata(Map.of("firebaseStorageDownloadTokens", downloadToken))
                    .build();

            StorageClient.getInstance(firebaseApp).bucket().getStorage().create(blobInfo, file.getBytes());
            return firebaseDownloadUrl(objectName, downloadToken);
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "이미지 업로드에 실패했습니다.");
        }
    }

    private FirebaseToken verifyToken(String idToken) {
        requireFirebase();

        try {
            return FirebaseAuth.getInstance(firebaseApp).verifyIdToken(idToken);
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "Firebase 토큰이 유효하지 않습니다.");
        }
    }

    private void requireFirebase() {
        if (firebaseApp == null) {
            throw new PlantItException(HttpStatus.SERVICE_UNAVAILABLE, "Firebase 설정이 필요합니다.");
        }
    }

    private void requireStorageBucket() {
        if (!hasText(storageBucket)) {
            throw new PlantItException(HttpStatus.SERVICE_UNAVAILABLE, "Firebase Storage 버킷 설정이 필요합니다.");
        }
    }

    private InputStream credentialsInputStream() throws Exception {
        if (hasText(credentialsJson)) {
            return new ByteArrayInputStream(credentialsJson.getBytes(StandardCharsets.UTF_8));
        }
        if (hasText(credentialsBase64)) {
            return new ByteArrayInputStream(Base64.getDecoder().decode(credentialsBase64));
        }
        return new FileInputStream(credentialsPath);
    }

    private boolean hasText(String value) {
        return value != null && !value.isBlank();
    }

    private String getExtension(String filename) {
        if (!hasText(filename) || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf("."));
    }

    private String firebaseDownloadUrl(String objectName, String downloadToken) {
        String encodedName = URLEncoder.encode(objectName, StandardCharsets.UTF_8);
        return "https://firebasestorage.googleapis.com/v0/b/"
                + storageBucket
                + "/o/"
                + encodedName
                + "?alt=media&token="
                + downloadToken;
    }
}
