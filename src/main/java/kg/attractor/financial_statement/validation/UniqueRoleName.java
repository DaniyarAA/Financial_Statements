//package kg.attractor.financial_statement.validation;
//
//import jakarta.validation.Constraint;
//import jakarta.validation.Payload;
//
//import java.lang.annotation.ElementType;
//import java.lang.annotation.Retention;
//import java.lang.annotation.RetentionPolicy;
//import java.lang.annotation.Target;
//
//@Target({ElementType.FIELD})
//@Retention(RetentionPolicy.RUNTIME)
//@Constraint(validatedBy = UniqueRoleNameValidator.class)
//
//public @interface UniqueRoleName {
//    String message() default "Роль с таким именем уже существует.";
//    Class<?>[] groups() default {};
//    Class<? extends Payload>[] payload() default {};
//}