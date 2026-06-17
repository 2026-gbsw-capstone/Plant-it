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
public class AdminTableRowDto {
    private Long id;
    private String editUrl;
    private String deleteUrl;
    private List<AdminTableCellDto> cells;
}
