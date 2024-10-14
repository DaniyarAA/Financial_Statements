package kg.attractor.financial_statement.dto;

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
public class TaskDto {
    private Long id;

    private String status;
    private LocalDate date;
    private LocalTime time;
    private String documentTypeName;
    private UserForTaskDto user;
    //    private Company company;
    //компании добавим после Чынгыза

}
