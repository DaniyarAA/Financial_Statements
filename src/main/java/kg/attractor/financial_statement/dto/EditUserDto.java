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
public class EditUserDto {
    private Long id;

    @NotBlank(message = "Заполните имя сотрулника!")
    private String name;

    @NotBlank(message = "Заполните фамилию сотрулника!")
    private String surname;

    @NotBlank(message = "Заполните логин сотрулника!")
    private String login;

    @NotNull(message = "Заполните дату рождения сотрулника!")
    private LocalDate birthday;
}