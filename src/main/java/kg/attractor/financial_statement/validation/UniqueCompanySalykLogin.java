package kg.attractor.financial_statement.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import kg.attractor.financial_statement.validation.impl.UniqueCompanySalykLoginValidator;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = UniqueCompanySalykLoginValidator.class)
@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface UniqueCompanySalykLogin {
    String message() default "Компания с таким логином Salyk.kg уже существует!";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
