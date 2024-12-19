//package kg.attractor.financial_statement.validation;
//
//import jakarta.validation.Constraint;
//import jakarta.validation.Payload;
//import kg.attractor.financial_statement.validation.impl.UniqueCompanyNameValidator;
//
//import java.lang.annotation.*;
//
//@Documented
//@Constraint(validatedBy = UniqueCompanyNameValidator.class)
//@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.PARAMETER})
//@Retention(RetentionPolicy.RUNTIME)
//public @interface UniqueCompanyName {
//    String message() default "Компания с таким именем уже существует , либо заорхивирована и можете восстановить !";
//    Class<?>[] groups() default {};
//    Class<? extends Payload>[] payload() default {};
//}
