package dev.siyoung.plantit.plantitbe.exception;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class ErrorResponse {
    private boolean success;
    private int httpStatus;
    private String message;
    private LocalDateTime timestamp;

    public static ErrorResponse of(int httpStatus, String message) {
        return ErrorResponse.builder()
                .success(false)
                .httpStatus(httpStatus)
                .message(message)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
