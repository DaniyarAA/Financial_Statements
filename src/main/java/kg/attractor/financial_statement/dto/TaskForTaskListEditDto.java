package kg.attractor.financial_statement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TaskForTaskListEditDto {
    private Long statusId;
    private String amount;
    private String description;
    private LocalDate from;
    private LocalDate to;
    private String fileName;
    private List<Long> userIds;
}
