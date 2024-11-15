package kg.attractor.financial_statement.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import kg.attractor.financial_statement.validation.impl.UniqueCompanyInnValidator;
import kg.attractor.financial_statement.validation.impl.UniqueCompanyLoginValidator;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = UniqueCompanyLoginValidator.class)
@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface UniqueCompanyLogin {
    String message() default "Компания с таким логином уже существует!";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
