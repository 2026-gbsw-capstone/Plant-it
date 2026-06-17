package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.user.MeResponseDto;
import dev.siyoung.plantit.plantitbe.dto.user.UpdateMeRequestDto;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.PlantRepository;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@RequiredArgsConstructor
@Service
@Transactional
public class UserService {
    private final UserRepository userRepository;
    private final PlantRepository plantRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public MeResponseDto fineUserById(Long id){
        return EntityDtoMapper.toDto(findUser(id));
    }

    public MeResponseDto updateUser(Long id, UpdateMeRequestDto request) {
        User user = findUser(id);

        if (request.getNickname() != null) {
            if (userRepository.existsByNicknameAndIdNot(request.getNickname(), id)) {
                throw new PlantItException(HttpStatus.CONFLICT, "이미 사용 중인 닉네임입니다.");
            }
            user.setNickname(request.getNickname());
        }
        if (request.getProfileImageUrl() != null) {
            user.setProfileImageUrl(request.getProfileImageUrl());
        }

        return EntityDtoMapper.toDto(user);
    }

    public void changePassword(Long id, String currentPassword, String newPassword) {
        User user = findUser(id);
        verifyPassword(user, currentPassword);
        user.setPassword(passwordEncoder.encode(newPassword));
    }

    public void deleteAccount(Long id, String password) {
        User user = findUser(id);
        verifyPassword(user, password);
        plantRepository.deleteAll(plantRepository.findByUserId(id));
        userRepository.delete(user);
    }

    public void resetData(Long id, String password) {
        User user = findUser(id);
        verifyPassword(user, password);
        plantRepository.deleteAll(plantRepository.findByUserId(id));
    }

    private void verifyPassword(User user, String password) {
        if (user.getPassword() == null) {
            throw new PlantItException(HttpStatus.BAD_REQUEST, "소셜 로그인 계정은 비밀번호로 인증할 수 없습니다.");
        }
        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new PlantItException(HttpStatus.UNAUTHORIZED, "비밀번호가 올바르지 않습니다.");
        }
    }

    private User findUser(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));
    }
}
