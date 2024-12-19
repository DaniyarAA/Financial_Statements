package kg.attractor.financial_statement.validation.impl;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.validation.UniqueCompanyLogin;
import org.springframework.beans.factory.annotation.Autowired;

public class UniqueCompanyLoginValidator implements ConstraintValidator<UniqueCompanyLogin, String> {

    @Autowired
    private CompanyService companyService;

    @Override
    public void initialize(UniqueCompanyLogin constraintAnnotation) {
        ConstraintValidator.super.initialize(constraintAnnotation);
    }

    @Override
    public boolean isValid(String companyLogin, ConstraintValidatorContext constraintValidatorContext) {
        if (companyLogin == null || companyLogin.isEmpty()) {
            return true;
        }
        return !companyService.existsByCompanyLogin(companyLogin);
    }
}
