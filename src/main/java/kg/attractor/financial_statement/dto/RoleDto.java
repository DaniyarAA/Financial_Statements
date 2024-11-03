package kg.attractor.financial_statement.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoleDto {
    @NotNull(message = "Выберите роль для сотрудника!")
    private Long id;
    private String roleName;
    private List<AuthorityDto> authorities;
    private List<Long> userIds;
}
