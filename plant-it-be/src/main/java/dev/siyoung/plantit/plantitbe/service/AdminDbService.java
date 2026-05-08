package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.dto.admin.AdminTableCellDto;
import dev.siyoung.plantit.plantitbe.dto.admin.AdminTableResponseDto;
import dev.siyoung.plantit.plantitbe.dto.admin.AdminTableRowDto;
import dev.siyoung.plantit.plantitbe.entity.NotificationHistory;
import dev.siyoung.plantit.plantitbe.entity.NotificationSetting;
import dev.siyoung.plantit.plantitbe.entity.Plant;
import dev.siyoung.plantit.plantitbe.entity.PlantAiAnalysis;
import dev.siyoung.plantit.plantitbe.entity.PlantDiary;
import dev.siyoung.plantit.plantitbe.entity.User;
import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import dev.siyoung.plantit.plantitbe.repository.NotificationHistoryRepository;
import dev.siyoung.plantit.plantitbe.repository.NotificationSettingRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantAiAnalysisRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantDiaryRepository;
import dev.siyoung.plantit.plantitbe.repository.PlantRepository;
import dev.siyoung.plantit.plantitbe.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminDbService {
    private final UserRepository userRepository;
    private final PlantRepository plantRepository;
    private final PlantDiaryRepository plantDiaryRepository;
    private final PlantAiAnalysisRepository plantAiAnalysisRepository;
    private final NotificationSettingRepository notificationSettingRepository;
    private final NotificationHistoryRepository notificationHistoryRepository;

    @Transactional(readOnly = true)
    public AdminTableResponseDto getTable(String table) {
        return switch (table) {
            case "users" -> users();
            case "plants" -> plants();
            case "diaries" -> diaries();
            case "ai-analyses" -> aiAnalyses();
            case "notification-settings" -> notificationSettings();
            case "notification-histories" -> notificationHistories();
            default -> throw new PlantItException(HttpStatus.NOT_FOUND, "관리 테이블을 찾을 수 없습니다.");
        };
    }

    public void delete(String table, Long id) {
        try {
            switch (table) {
                case "users" -> userRepository.deleteById(id);
                case "plants" -> plantRepository.deleteById(id);
                case "diaries" -> plantDiaryRepository.deleteById(id);
                case "ai-analyses" -> plantAiAnalysisRepository.deleteById(id);
                case "notification-settings" -> notificationSettingRepository.deleteById(id);
                case "notification-histories" -> notificationHistoryRepository.deleteById(id);
                default -> throw new PlantItException(HttpStatus.NOT_FOUND, "관리 테이블을 찾을 수 없습니다.");
            }
        } catch (DataIntegrityViolationException e) {
            throw new PlantItException(HttpStatus.CONFLICT, "연결된 데이터가 있어 삭제할 수 없습니다.");
        }
    }

    private AdminTableResponseDto users() {
        List<AdminTableRowDto> rows = userRepository.findAll().stream()
                .map(user -> row("users", user.getId(),
                        user.getEmail(),
                        user.getNickname(),
                        user.getLoginType(),
                        user.getCreatedAt()))
                .toList();
        return table("users", "사용자", List.of("이메일", "닉네임", "로그인 타입", "가입일"), rows);
    }

    private AdminTableResponseDto plants() {
        List<AdminTableRowDto> rows = plantRepository.findAll().stream()
                .map(plant -> row("plants", plant.getId(),
                        idOf(plant.getUser()),
                        plant.getName(),
                        plant.getSpeciesName(),
                        plant.getHealthStatus(),
                        plant.getRegisteredAt()))
                .toList();
        return table("plants", "식물", List.of("사용자 ID", "이름", "종 이름", "건강상태", "등록일"), rows);
    }

    private AdminTableResponseDto diaries() {
        List<AdminTableRowDto> rows = plantDiaryRepository.findAll().stream()
                .map(diary -> row("diaries", diary.getId(),
                        idOf(diary.getPlant()),
                        diary.getRecordedAt(),
                        shorten(diary.getNote()),
                        diary.getCreatedAt()))
                .toList();
        return table("diaries", "성장일지", List.of("식물 ID", "기록일", "메모", "생성일"), rows);
    }

    private AdminTableResponseDto aiAnalyses() {
        List<AdminTableRowDto> rows = plantAiAnalysisRepository.findAll().stream()
                .map(analysis -> row("ai-analyses", analysis.getId(),
                        idOf(analysis.getPlant()),
                        analysis.getAnalysisType(),
                        analysis.getResultStatus(),
                        shorten(analysis.getResultText()),
                        analysis.getCreatedAt()))
                .toList();
        return table("ai-analyses", "AI 분석", List.of("식물 ID", "분석 타입", "상태", "결과", "생성일"), rows);
    }

    private AdminTableResponseDto notificationSettings() {
        List<AdminTableRowDto> rows = notificationSettingRepository.findAll().stream()
                .map(setting -> row("notification-settings", setting.getId(),
                        idOf(setting.getUser()),
                        idOf(setting.getPlant()),
                        setting.getWateringEnabled(),
                        setting.getFertilizerEnabled(),
                        setting.getGrowthRecordEnabled(),
                        setting.getNotificationTime()))
                .toList();
        return table("notification-settings", "알림 설정", List.of("사용자 ID", "식물 ID", "물", "비료", "성장기록", "알림시간"), rows);
    }

    private AdminTableResponseDto notificationHistories() {
        List<AdminTableRowDto> rows = notificationHistoryRepository.findAll().stream()
                .map(history -> row("notification-histories", history.getId(),
                        idOf(history.getUser()),
                        idOf(history.getPlant()),
                        history.getNotificationType(),
                        history.getNotifiedDate(),
                        history.getCreatedAt()))
                .toList();
        return table("notification-histories", "알림 기록", List.of("사용자 ID", "식물 ID", "타입", "알림일", "생성일"), rows);
    }

    private AdminTableResponseDto table(String table, String title, List<String> headers, List<AdminTableRowDto> rows) {
        return AdminTableResponseDto.builder()
                .table(table)
                .title(title)
                .headers(headers)
                .rows(rows)
                .hasRows(!rows.isEmpty())
                .build();
    }

    private AdminTableRowDto row(String table, Long id, Object... values) {
        return AdminTableRowDto.builder()
                .id(id)
                .deleteUrl("/admin/db/" + table + "/" + id + "/delete")
                .cells(Arrays.stream(values)
                        .map(value -> AdminTableCellDto.builder().value(value(value)).build())
                        .toList())
                .build();
    }

    private Long idOf(User user) {
        return user == null ? null : user.getId();
    }

    private Long idOf(Plant plant) {
        return plant == null ? null : plant.getId();
    }

    private String shorten(String value) {
        if (value == null) {
            return "";
        }
        return value.length() <= 80 ? value : value.substring(0, 80) + "...";
    }

    private String value(Object value) {
        return value == null ? "" : String.valueOf(value);
    }
}
