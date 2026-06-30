package dev.siyoung.plantit.plantitbe.service;

import dev.siyoung.plantit.plantitbe.exception.PlantItException;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private final JavaMailSender javaMailSender;

    @Value("${mail.from:}")
    private String from;

    @Value("${spring.mail.host:}")
    private String mailHost;

    public void sendPasswordResetCode(String to, String code, LocalDateTime expiresAt) {
        if (mailHost == null || mailHost.isBlank()) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "메일 서버 설정이 누락되었습니다.");
        }

        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, "UTF-8");

            if (from != null && !from.isBlank()) {
                helper.setFrom(from);
            }
            helper.setTo(to);
            helper.setSubject("[Plant-it] 비밀번호 재설정 인증 코드");
            helper.setText(buildPasswordResetText(code, expiresAt), false);

            javaMailSender.send(message);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send password reset email to: {}", to, e);
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "비밀번호 재설정 메일 발송에 실패했습니다. 관리자에게 문의해주세요.");
        } catch (IllegalArgumentException e) {
            log.error("Invalid mail address or sender configuration: to={}, from={}", to, from, e);
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "메일 주소 형식 또는 발신자 설정이 올바르지 않습니다.");
        }
    }

    public void sendSignupVerificationCode(String to, String code, LocalDateTime expiresAt) {
        if (mailHost == null || mailHost.isBlank()) {
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "메일 서버 설정이 누락되었습니다.");
        }

        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, "UTF-8");

            if (from != null && !from.isBlank()) {
                helper.setFrom(from);
            }
            helper.setTo(to);
            helper.setSubject("[Plant-it] 회원가입 이메일 인증 코드");
            helper.setText(buildSignupVerificationText(code, expiresAt), false);

            javaMailSender.send(message);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send signup verification email to: {}", to, e);
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "인증 메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.");
        } catch (IllegalArgumentException e) {
            log.error("Invalid mail address or sender configuration: to={}, from={}", to, from, e);
            throw new PlantItException(HttpStatus.BAD_GATEWAY, "메일 주소 형식 또는 발신자 설정이 올바르지 않습니다.");
        }
    }

    private String buildPasswordResetText(String code, LocalDateTime expiresAt) {
        return "Plant-it 비밀번호 재설정 인증 코드입니다.\n\n"
                + "인증 코드: " + code + "\n"
                + "만료 시간: " + expiresAt.format(DATE_TIME_FORMATTER) + "\n\n"
                + "본인이 요청하지 않았다면 이 메일을 무시해주세요.";
    }

    private String buildSignupVerificationText(String code, LocalDateTime expiresAt) {
        return "Plant-it 회원가입 이메일 인증 코드입니다.\n\n"
                + "인증 코드: " + code + "\n"
                + "만료 시간: " + expiresAt.format(DATE_TIME_FORMATTER) + "\n\n"
                + "본인이 요청하지 않았다면 이 메일을 무시해주세요.";
    }
}
