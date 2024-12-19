package kg.attractor.financial_statement.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateRoleDto {
    @NotNull(message = "Выберите роль для сотрудника!")
//    @UniqueRoleName(message = "Роль с данным наименованием уже существуют")
    private String roleName;
    private List<Long> authorityIds;
}
