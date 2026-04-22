package dev.siyoung.plantit.plantitbe.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "notification_settings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationSetting {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, foreignKey = @ForeignKey(name = "fk_notification_user"))
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plant_id", foreignKey = @ForeignKey(name = "fk_notification_plant"))
    private Plant plant;

    @Column(name = "watering_enabled", nullable = false)
    @Builder.Default
    private Boolean wateringEnabled = true;

    @Column(name = "fertilizer_enabled", nullable = false)
    @Builder.Default
    private Boolean fertilizerEnabled = true;

    @Column(name = "growth_record_enabled", nullable = false)
    @Builder.Default
    private Boolean growthRecordEnabled = true;

    @Column(name = "push_token", length = 512)
    private String pushToken;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
