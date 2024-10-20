package kg.attractor.financial_statement.dto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import kg.attractor.financial_statement.validation.UniqueLogin;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;

@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private Long id;

    @NotBlank(message = "Заполните имя сотрулника!")
    private String name;

    @NotBlank(message = "Заполните фамилию сотрулника!")
    private String surname;

    @NotBlank(message = "Заполните логин сотрулника!")
    @UniqueLogin(message = "Пользователь с такой логинкой уже существует")
    private String login;

    @NotBlank(message = "Заполните имя сотрулника!")
    @Size(min = 8, max = 20, message = "Пароль минимум должен содержать 8 символов, максимум 20")
    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "Пароль должен содержать минимум 1 символ верхнего регистра, 1 символ нижнего регистра и минимум 1 символ")
    private String password;

    private LocalDate registrationDate;

    private boolean isActive;
  //  private String avatar;
    private boolean enabled;

    @NotNull(message = "Заполните дату рождения сотрулника!")
    private LocalDate birthday;

    @NotNull(message = "Выберите роль для сотрулника!")
    private Long roleId;
}
