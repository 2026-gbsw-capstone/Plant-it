package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.user.MeResponseDto;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import dev.siyoung.plantit.plantitbe.utils.EntityDtoMapper;
import io.swagger.v3.oas.annotations.servers.Server;
import lombok.RequiredArgsConstructor;
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
        return EntityDtoMapper.toDto(userRepository.findById(id).orElseThrow());
    }
}
