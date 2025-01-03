package kg.attractor.financial_statement.validation;


import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UniqueLoginValidator implements ConstraintValidator<UniqueLogin, String> {

    private final UserService userService;

    @Override
    public boolean isValid(String login, ConstraintValidatorContext context) {
        userService.checkIfUserExistsByLogin(login);
        return login != null && !userService.checkIfUserExistsByLogin(login);
    }
}
