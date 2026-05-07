package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.user.MeResponseDto;
import dev.siyoung.plantit.plantitbe.dto.user.UpdateMeRequestDto;
import dev.siyoung.plantit.plantitbe.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/users")
public class UserController {
    private static final Long DEFAULT_USER_ID = 1L;

    private final UserService userService;

    @GetMapping("/all")
    public ResponseEntity<List<MeResponseDto>> getAllUsers() {
        return ResponseEntity.ok(userService.findAllUsers());
    }

    @GetMapping("/me")
    public ResponseEntity<MeResponseDto> getMe() {
        return ResponseEntity.ok(userService.fineUserById(DEFAULT_USER_ID));
    }

    @PatchMapping("/me")
    public ResponseEntity<MeResponseDto> updateMe(@RequestBody UpdateMeRequestDto request) {
        return ResponseEntity.ok(userService.updateUser(DEFAULT_USER_ID, request));
    }
}
