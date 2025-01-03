package kg.attractor.financial_statement.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import kg.attractor.financial_statement.validation.impl.PasswordMatchValidator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = PasswordMatchValidator.class)
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface PasswordMatch {
    String message() default "Пароли не совпадают!";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
