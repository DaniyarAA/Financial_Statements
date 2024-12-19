//package kg.attractor.financial_statement.validation;
//
//import jakarta.validation.ConstraintValidator;
//import jakarta.validation.ConstraintValidatorContext;
//import kg.attractor.financial_statement.service.UserService;
//import lombok.RequiredArgsConstructor;
//import org.springframework.stereotype.Component;
//
//@Component
//@RequiredArgsConstructor
//public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {
//    private final UserService userService;
//
//    @Override
//    public boolean isValid(String email, ConstraintValidatorContext context) {
//        userService.checkIfUserExistsByEmail(email);
//        return email != null && !userService.checkIfUserExistsByEmail(email);
//    }
//}
