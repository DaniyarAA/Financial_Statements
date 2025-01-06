package kg.attractor.financial_statement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor

public class TaskCreateDto {
    private Long documentTypeId;
    private Long appointToUserId;
    private Long companyId;
    private Long taskStatusId;
    private LocalDate startDate;
    private LocalDate endDate;
    private String description;
}
