package dev.siyoung.plantit.plantitbe.dto.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AdminTableResponseDto {
    private String table;
    private String title;
    private List<String> headers;
    private List<AdminTableRowDto> rows;
    private boolean hasRows;
}
