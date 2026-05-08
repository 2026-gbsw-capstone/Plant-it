package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
public class EmailService {
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private final JavaMailSender javaMailSender;

    @Value("${mail.from:}")
    private String from;

    public void sendPasswordResetCode(String to, String code, LocalDateTime expiresAt) {
        SimpleMailMessage message = new SimpleMailMessage();
        if (from != null && !from.isBlank()) {
            message.setFrom(from);
        }
        message.setTo(to);
        message.setSubject("[Plant-it] 비밀번호 재설정 인증 코드");
        message.setText(buildPasswordResetText(code, expiresAt));

        try {
            javaMailSender.send(message);
        } catch (MailException e) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "비밀번호 재설정 메일 발송에 실패했습니다.");
        }
    }

    private String buildPasswordResetText(String code, LocalDateTime expiresAt) {
        return "Plant-it 비밀번호 재설정 인증 코드입니다.\n\n"
                + "인증 코드: " + code + "\n"
                + "만료 시간: " + expiresAt.format(DATE_TIME_FORMATTER) + "\n\n"
                + "본인이 요청하지 않았다면 이 메일을 무시해주세요.";
    }
}
