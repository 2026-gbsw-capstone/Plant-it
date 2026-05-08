package dev.siyoung.plantit.plantitbe.dto.admin;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AiPromptFormDto {
    @NotBlank(message = "프롬프트 제목은 필수입니다.")
    private String title;

    @NotBlank(message = "프롬프트 내용은 필수입니다.")
    private String content;

    public String getTitle() {
        return valueOrEmpty(title);
    }

    public String getContent() {
        return valueOrEmpty(content);
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }
}
