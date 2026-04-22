package dev.siyoung.plantit.plantitbe.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "plant_diaries")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlantDiary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plant_id", nullable = false, foreignKey = @ForeignKey(name = "fk_diary_plant"))
    private Plant plant;

    @Column(name = "image_url", length = 2048)
    private String imageUrl;

    @Column(columnDefinition = "TEXT")
    private String note;

    @Column(name = "recorded_at", nullable = false)
    private LocalDateTime recordedAt;

    @Column(name = "ai_health_summary", columnDefinition = "TEXT")
    private String aiHealthSummary;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
