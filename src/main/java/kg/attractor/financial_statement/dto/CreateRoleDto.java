package kg.attractor.financial_statement.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import kg.attractor.financial_statement.validation.UniqueRoleName;
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

    @UniqueRoleName(message = "Название для роли должно быть уникальным")
    @NotBlank(message = "Название роли не может быть пустым")
    private String roleName;

    @NotEmpty(message = "выберите хотя бы одно полномочие")
    private List<Long> authorityIds;
}
