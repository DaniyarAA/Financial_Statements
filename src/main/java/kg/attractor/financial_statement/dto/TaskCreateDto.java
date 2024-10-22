package kg.attractor.financial_statement.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TaskCreateDto {
//    private LocalDate date;
//    private LocalTime time;

    private Long documentTypeId;
    private String userLogin;
    private Long companyId;
}
