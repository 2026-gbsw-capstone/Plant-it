package dev.siyoung.plantit.plantitbe.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(PlantItException.class)
    public Object handlePlantItException(PlantItException exception, HttpServletRequest request) {
        if (isAdminRequest(request)) {
            return handleAdminException(exception.getMessage());
        }
        HttpStatus httpStatus = exception.getHttpStatus();
        return ResponseEntity.status(httpStatus)
                .body(ErrorResponse.of(httpStatus.value(), exception.getMessage()));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseBody
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(IllegalArgumentException exception) {
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(httpStatus)
                .body(ErrorResponse.of(httpStatus.value(), exception.getMessage()));
    }

    @ExceptionHandler(NoSuchElementException.class)
    @ResponseBody
    public ResponseEntity<ErrorResponse> handleNoSuchElementException(NoSuchElementException exception) {
        HttpStatus httpStatus = HttpStatus.NOT_FOUND;
        return ResponseEntity.status(httpStatus)
                .body(ErrorResponse.of(httpStatus.value(), "요청한 데이터를 찾을 수 없습니다."));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseBody
    public ResponseEntity<ErrorResponse> handleMethodArgumentNotValidException(MethodArgumentNotValidException exception) {
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;
        String message = exception.getBindingResult().getFieldErrors().stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.joining(", "));

        return ResponseEntity.status(httpStatus)
                .body(ErrorResponse.of(httpStatus.value(), message));
    }

    @ExceptionHandler(Exception.class)
    public Object handleException(Exception exception, HttpServletRequest request) {
        log.error("Unhandled exception", exception);
        if (isAdminRequest(request)) {
            return handleAdminException("서버 오류가 발생했습니다.");
        }
        HttpStatus httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
        return ResponseEntity.status(httpStatus)
                .body(ErrorResponse.of(httpStatus.value(), "서버 오류가 발생했습니다."));
    }

    private boolean isAdminRequest(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String accept = request.getHeader("Accept");
        return uri.startsWith("/admin") && (accept != null && accept.contains("text/html"));
    }

    private ResponseEntity<String> handleAdminException(String message) {
        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", "text/html;charset=UTF-8")
                .body("<script>alert('" + message + "'); history.back();</script>");
    }
}
