package kg.attractor.financial_statement.validation.impl;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.validation.UniqueCompanyInn;
import org.springframework.beans.factory.annotation.Autowired;

public class UniqueCompanyInnValidator implements ConstraintValidator<UniqueCompanyInn, String> {
    @Autowired
    private CompanyService companyService;

    @Override
    public void initialize(UniqueCompanyInn constraintAnnotation) {
        ConstraintValidator.super.initialize(constraintAnnotation);
    }

    @Override
    public boolean isValid(String companyInn, ConstraintValidatorContext constraintValidatorContext) {
        if (companyInn == null || companyInn.isEmpty()) {
            return true;
        }
        return !companyService.existsByCompanyInn(companyInn);
    }
}
