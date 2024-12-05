package kg.attractor.financial_statement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TaskForTaskListEditDto {
    private Long statusId;
    private String amount;
    private String description;
    private String from;
    private String to;
}
