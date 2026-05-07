package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.user.MeResponseDto;
import dev.siyoung.plantit.plantitbe.dto.user.UpdateMeRequestDto;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
@Transactional
public class UserService {
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<MeResponseDto> findAllUsers() {
        return userRepository.findAll().stream().map(EntityDtoMapper::toDto).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public MeResponseDto fineUserById(Long id){
        return EntityDtoMapper.toDto(findUser(id));
    }

    public MeResponseDto updateUser(Long id, UpdateMeRequestDto request) {
        User user = findUser(id);

        if (request.getNickname() != null) {
            user.setNickname(request.getNickname());
        }
        if (request.getProfileImageUrl() != null) {
            user.setProfileImageUrl(request.getProfileImageUrl());
        }

        return EntityDtoMapper.toDto(user);
    }

    private User findUser(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new PlantItException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));
    }
}
