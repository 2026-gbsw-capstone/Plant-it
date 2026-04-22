package dev.siyoung.plantit.plantitbe.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "plant_ai_analyses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlantAiAnalysis {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plant_id", nullable = false, foreignKey = @ForeignKey(name = "fk_analysis_plant"))
    private Plant plant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "diary_id", foreignKey = @ForeignKey(name = "fk_analysis_diary"))
    private PlantDiary diary;

    @Column(name = "image_url", length = 2048)
    private String imageUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "analysis_type", nullable = false, length = 30)
    private AnalysisType analysisType;

    @Column(name = "result_text", nullable = false, columnDefinition = "TEXT")
    private String resultText;

    @Enumerated(EnumType.STRING)
    @Column(name = "result_status", nullable = false, length = 20)
    private ResultStatus resultStatus;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public enum AnalysisType {
        SPECIES_IDENTIFICATION,
        HEALTH_ANALYSIS,
        CHAT
    }

    public enum ResultStatus {
        SUCCESS,
        FAILED
    }
}
