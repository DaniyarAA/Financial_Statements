package kg.attractor.financial_statement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor

public class TaskEditDto {
    private Long documentTypeId;
    private String userLogin;
    private Long companyId;
    private LocalDateTime startDateTime;
    private LocalDateTime endDateTime;
}
