package kg.attractor.financial_statement.dto;

import kg.attractor.financial_statement.entity.Task;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.util.List;

@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class UserCompanyDto {

    private Long id;
    private Long userId;
    private Long companyId;
    private List<Task> tasks;//TODO TaskDto
}
