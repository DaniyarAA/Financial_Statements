//package kg.attractor.financial_statement.validation.impl;
//
//import jakarta.validation.ConstraintValidator;
//import jakarta.validation.ConstraintValidatorContext;
//import kg.attractor.financial_statement.service.CompanyService;
//import kg.attractor.financial_statement.validation.UniqueCompanyDirectorInn;
//import org.springframework.beans.factory.annotation.Autowired;
//
//public class UniqueCompanyDirectorInnValidator implements ConstraintValidator<UniqueCompanyDirectorInn, String> {
//
//    @Autowired
//    private CompanyService companyService;
//
//    @Override
//    public void initialize(UniqueCompanyDirectorInn constraintAnnotation) {
//        ConstraintValidator.super.initialize(constraintAnnotation);
//    }
//
//    @Override
//    public boolean isValid(String companyDirectorInn, ConstraintValidatorContext constraintValidatorContext) {
//        if (companyDirectorInn == null || companyDirectorInn.isEmpty()) {
//            return true;
//        }
//        return !companyService.existsByCompanyDirectorInn(companyDirectorInn);
//    }
//}
