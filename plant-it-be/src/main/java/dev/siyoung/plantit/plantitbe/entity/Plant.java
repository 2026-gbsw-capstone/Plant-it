package dev.siyoung.plantit.plantitbe.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "plants")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Plant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, foreignKey = @ForeignKey(name = "fk_plant_user"))
    private User user;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(name = "species_name", length = 100)
    private String speciesName;

    @Column(name = "plant_image_url", length = 2048)
    private String plantImageUrl;

    @Column(name = "registered_at", nullable = false)
    private LocalDateTime registeredAt;

    @Column(name = "last_watered_at")
    private LocalDateTime lastWateredAt;

    @Column(name = "last_fertilized_at")
    private LocalDateTime lastFertilizedAt;

    @Column(name = "watering_cycle_days")
    private Integer wateringCycleDays;

    @Column(name = "fertilizer_cycle_days")
    private Integer fertilizerCycleDays;

    @Enumerated(EnumType.STRING)
    @Column(name = "health_status", nullable = false, length = 20)
    @Builder.Default
    private HealthStatus healthStatus = HealthStatus.GOOD;

    @Column(columnDefinition = "TEXT")
    private String memo;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public enum HealthStatus {
        GOOD,
        WARNING,
        DANGER
    }
}
