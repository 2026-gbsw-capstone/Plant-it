package dev.siyoung.plantit.plantitbe.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class PlantItException extends RuntimeException {
    private final HttpStatus httpStatus;

    public PlantItException(HttpStatus httpStatus, String message) {
        super(message);
        this.httpStatus = httpStatus;
    }
}
