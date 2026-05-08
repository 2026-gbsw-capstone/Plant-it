package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.PasswordResetToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {
    Optional<PasswordResetToken> findTopByUserEmailAndCodeAndUsedFalseOrderByCreatedAtDesc(String email, String code);
    Optional<PasswordResetToken> findByResetTokenAndVerifiedTrueAndUsedFalse(String resetToken);
}
