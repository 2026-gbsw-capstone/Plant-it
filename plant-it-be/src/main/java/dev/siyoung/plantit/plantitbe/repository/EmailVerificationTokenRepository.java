package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.EmailVerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface EmailVerificationTokenRepository extends JpaRepository<EmailVerificationToken, Long> {
    Optional<EmailVerificationToken> findTopByEmailAndCodeAndUsedFalseOrderByCreatedAtDesc(String email, String code);

    Optional<EmailVerificationToken> findTopByEmailAndVerifiedTrueAndUsedFalseOrderByCreatedAtDesc(String email);

    /**
     * 새 인증 코드를 발급하기 전에, 해당 이메일로 아직 사용되지 않은 기존 코드를 모두 무효화한다.
     */
    @Modifying(clearAutomatically = true)
    @Query("UPDATE EmailVerificationToken t SET t.used = true WHERE t.email = :email AND t.used = false")
    void invalidateActiveTokensByEmail(@Param("email") String email);
}
