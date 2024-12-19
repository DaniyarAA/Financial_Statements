//package kg.attractor.financial_statement.validation.impl;
//
//import jakarta.validation.ConstraintValidator;
//import jakarta.validation.ConstraintValidatorContext;
//import kg.attractor.financial_statement.service.CompanyService;
//import kg.attractor.financial_statement.validation.UniqueCompanyName;
//import org.springframework.beans.factory.annotation.Autowired;
//
//public class UniqueCompanyNameValidator implements ConstraintValidator<UniqueCompanyName, String> {
//
//    @Autowired
//    private CompanyService companyService;
//
//    @Override
//    public void initialize(UniqueCompanyName constraintAnnotation) {
//        ConstraintValidator.super.initialize(constraintAnnotation);
//    }
//
//    @Override
//    public boolean isValid(String companyName, ConstraintValidatorContext constraintValidatorContext) {
//        if (companyName == null || companyName.isEmpty()) {
//            return true;
//        }
//        return !companyService.existsByCompanyName(companyName);
//    }
//}
