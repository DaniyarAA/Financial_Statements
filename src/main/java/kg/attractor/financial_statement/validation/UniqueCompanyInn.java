//package kg.attractor.financial_statement.validation;
//
//import jakarta.validation.Constraint;
//import jakarta.validation.Payload;
//import kg.attractor.financial_statement.validation.impl.UniqueCompanyInnValidator;
//
//import java.lang.annotation.*;
//
//@Documented
//@Constraint(validatedBy = UniqueCompanyInnValidator.class)
//@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.PARAMETER})
//@Retention(RetentionPolicy.RUNTIME)
//public @interface UniqueCompanyInn {
//    String message() default "Компания с таким ИНН уже существует!";
//    Class<?>[] groups() default {};
//    Class<? extends Payload>[] payload() default {};
//}
