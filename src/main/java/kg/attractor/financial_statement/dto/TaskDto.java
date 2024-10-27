package kg.attractor.financial_statement.dto;

import kg.attractor.financial_statement.entity.Company;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor

public class TaskDto {
    private Long id;
    private String statusId;
    private LocalDateTime startDateTime;
    private LocalDateTime endDateTime;
    private String documentTypeName;
    private UserForTaskDto user;
    private CompanyForTaskDto company;

    private BigDecimal amount;
    private String description;

}
