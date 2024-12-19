package kg.attractor.financial_statement.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import kg.attractor.financial_statement.validation.impl.UniqueCompanyDirectorInnValidator;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = UniqueCompanyDirectorInnValidator.class)
@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface UniqueCompanyDirectorInn {
    String message() default "Компания с таким ИНН директором уже существует!";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
