package kg.attractor.financial_statement.validation.impl;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.validation.PasswordMatch;

public class PasswordMatchValidator implements ConstraintValidator<PasswordMatch, UserDto> {

    @Override
    public boolean isValid(UserDto userDto, ConstraintValidatorContext context) {
        if (userDto.getPassword() == null || userDto.getConfirmPassword() == null) {
            return true;
        }
        if (!userDto.getPassword().equals(userDto.getConfirmPassword())) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate("Пароли не совпадают!")
                    .addPropertyNode("confirmPassword")
                    .addConstraintViolation();
            return false;
        }
        return true;
    }
}
