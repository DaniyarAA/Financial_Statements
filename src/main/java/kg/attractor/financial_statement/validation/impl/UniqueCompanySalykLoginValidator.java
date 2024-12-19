//package kg.attractor.financial_statement.validation.impl;
//
//import jakarta.validation.ConstraintValidator;
//import jakarta.validation.ConstraintValidatorContext;
//import kg.attractor.financial_statement.service.CompanyService;
//import kg.attractor.financial_statement.validation.UniqueCompanySalykLogin;
//import org.springframework.beans.factory.annotation.Autowired;
//
//public class UniqueCompanySalykLoginValidator implements ConstraintValidator<UniqueCompanySalykLogin, String> {
//
//    @Autowired
//    private CompanyService companyService;
//
//    @Override
//    public void initialize(UniqueCompanySalykLogin constraintAnnotation) {
//        ConstraintValidator.super.initialize(constraintAnnotation);
//    }
//
//    @Override
//    public boolean isValid(String salykLogin, ConstraintValidatorContext constraintValidatorContext) {
//        if (salykLogin == null || salykLogin.isEmpty()) {
//            return true;
//        }
//        return !companyService.existsByCompanySalykLogin(salykLogin);
//    }
//}
