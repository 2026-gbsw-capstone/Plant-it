package dev.siyoung.plantit.plantitbe.security;

import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Base64;

@Component
public class JwtTokenProvider {
    private static final String HMAC_ALGORITHM = "HmacSHA256";

    @Value("${jwt.secret:plant-it-local-development-secret-key}")
    private String secret;

    @Value("${jwt.access-token-expiration-seconds:3600}")
    private long accessTokenExpirationSeconds;

    @Value("${jwt.refresh-token-expiration-seconds:1209600}")
    private long refreshTokenExpirationSeconds;

    public String createAccessToken(Long userId) {
        return createToken(userId, accessTokenExpirationSeconds);
    }

    public String createRefreshToken(Long userId) {
        return createToken(userId, refreshTokenExpirationSeconds);
    }

    public Long getUserId(String token) {
        validate(token);
        String payloadJson = new String(base64UrlDecode(token.split("\\.")[1]), StandardCharsets.UTF_8);
        String subject = extractJsonValue(payloadJson, "sub");
        return Long.valueOf(subject);
    }

    public LocalDateTime getExpiresAt(String token) {
        validate(token);
        String payloadJson = new String(base64UrlDecode(token.split("\\.")[1]), StandardCharsets.UTF_8);
        long expiration = Long.parseLong(extractJsonValue(payloadJson, "exp"));
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(expiration), ZoneId.systemDefault());
    }

    public void validate(String token) {
        String[] parts = token.split("\\.");
        if (parts.length != 3) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.");
        }

        String unsignedToken = parts[0] + "." + parts[1];
        String expectedSignature = hmacSha256(unsignedToken);
        if (!expectedSignature.equals(parts[2])) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.");
        }

        String payloadJson = new String(base64UrlDecode(parts[1]), StandardCharsets.UTF_8);
        long expiration = Long.parseLong(extractJsonValue(payloadJson, "exp"));
        if (expiration < Instant.now().getEpochSecond()) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "만료된 토큰입니다.");
        }
    }

    private String createToken(Long userId, long expirationSeconds) {
        String header = base64UrlEncode("{\"alg\":\"HS256\",\"typ\":\"JWT\"}".getBytes(StandardCharsets.UTF_8));
        long expiration = Instant.now().plusSeconds(expirationSeconds).getEpochSecond();
        String payload = "{\"sub\":\"" + userId + "\",\"exp\":" + expiration + "}";
        String encodedPayload = base64UrlEncode(payload.getBytes(StandardCharsets.UTF_8));
        String unsignedToken = header + "." + encodedPayload;
        return unsignedToken + "." + hmacSha256(unsignedToken);
    }

    private String hmacSha256(String value) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            SecretKeySpec key = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM);
            mac.init(key);
            return base64UrlEncode(mac.doFinal(value.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            throw new PlantItException(HttpStatus.INTERNAL_SERVER_ERROR, "토큰 생성 중 오류가 발생했습니다.");
        }
    }

    private String extractJsonValue(String json, String key) {
        String keyPattern = "\"" + key + "\":";
        int keyIndex = json.indexOf(keyPattern);
        if (keyIndex < 0) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.");
        }

        int valueStart = keyIndex + keyPattern.length();
        if (json.charAt(valueStart) == '"') {
            int start = valueStart + 1;
            int end = json.indexOf('"', start);
            return json.substring(start, end);
        }

        int end = json.indexOf(',', valueStart);
        if (end < 0) {
            end = json.indexOf('}', valueStart);
        }
        return json.substring(valueStart, end);
    }

    private String base64UrlEncode(byte[] value) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(value);
    }

    private byte[] base64UrlDecode(String value) {
        return Base64.getUrlDecoder().decode(value);
    }
}
