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

public class TaskDto {
    private Long id;
    private String statusId;
    private LocalDate startDate;
    private LocalDate endDate;
    private String documentTypeName;
    private UserForTaskDto user;
    private CompanyForTaskDto company;
    private BigDecimal amount;
    private String description;
    private boolean isDeleted;
}
