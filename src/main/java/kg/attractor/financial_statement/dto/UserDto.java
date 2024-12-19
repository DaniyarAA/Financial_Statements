package kg.attractor.financial_statement.dto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
//import kg.attractor.financial_statement.validation.UniqueEmail;
//import kg.attractor.financial_statement.validation.UniqueLogin;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.util.List;

@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private Long id;

    @NotBlank(message = "Заполните имя сотрудника!")
    private String name;

    @NotBlank(message = "Заполните фамилию сотрудника!")
    private String surname;

    @NotBlank(message = "Заполните логин сотрудника!")
//    @UniqueLogin
    private String login;

    @NotBlank(message = "Заполните пароль сотрудника!")
    @Size(min = 8, max = 20, message = "Пароль минимум должен содержать 8 символов, максимум 20")
    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "Пароль должен содержать минимум 1 символ верхнего регистра, 1 символ нижнего регистра и минимум 1 символ")
    private String password;

    private LocalDate registerDate;

    private String avatar;
    private boolean enabled;

    @NotNull(message = "Заполните дату рождения сотрудника!")
    private LocalDate birthday;

    @Valid
    private RoleDto roleDto;

    @NotBlank(message = "Введите адрес электронной почты!")
    @Email(message = "Введите корректный адрес почты!")
//    @UniqueEmail
    private String email;

    private String notes;

    private int displayIndex;
    private List<CompanyDto> companies;
    private List<Long> companyIds;
}
