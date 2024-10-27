package kg.attractor.financial_statement.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import kg.attractor.financial_statement.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;


@Component
@RequiredArgsConstructor
public class UniqueRoleNameValidator implements ConstraintValidator<UniqueRoleName, String> {

    private final RoleService roleService;

    @Override
    public boolean isValid(String roleName, ConstraintValidatorContext constraintValidatorContext) {
        roleService.checkIfRoleNameExists(roleName);
        return roleName != null && !roleService.checkIfRoleNameExists(roleName);
    }
}
