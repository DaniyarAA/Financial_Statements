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
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class EditUserDto {
    private Long id;

    @NotBlank(message = "Заполните имя сотрудника!")
    private String name;

    @NotBlank(message = "Заполните фамилию сотрудника!")
    private String surname;

    @NotBlank(message = "Заполните логин сотрудника!")
    private String login;

    @NotNull(message = "Заполните дату рождения сотрудника!")
    private LocalDate birthday;
    private MultipartFile avatar;
}