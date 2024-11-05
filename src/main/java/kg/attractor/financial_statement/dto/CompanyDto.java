package kg.attractor.financial_statement.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CompanyDto {
    private Long id;
    @NotBlank(message = "Обязательно для заполнения!")
    private String name;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 20, message = "Размер ИНН не может быть больше 20")
    private String companyInn;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 20, message = "Размер ИНН не может быть больше 20")
    private String directorInn;
    @NotBlank(message = "Обязательно для заполнения!")
    private String login;
    @NotBlank(message = "Обязательно для заполнения!")
    private String password;
    @NotBlank(message = "Обязательно для заполнения!")
    private String ecp;
    @NotBlank(message = "Обязательно для заполнения!")
    private String kabinetSalyk;
    @NotBlank(message = "Обязательно для заполнения!")
    private String kabinetSalykPassword;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 75, message = "Размер налогооблажения не может быть больше 75")
    private String taxMode;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 75, message = "Размер ОПФ не может быть больше 75")
    private String opf;
    @NotBlank(message = "Обязательно для заполнения!")
    private String districtGns;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 20, message = "Размер социального фонда не может быть больше 20")
    private String socfundNumber;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 50, message = "Размер регистрационного номера МЮ не может быть больше 50")
    private String registrationNumberMj;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 20, message = "Размер ОКПО не может быть больше 20")
    private String okpo;
    @NotBlank(message = "Обязательно для заполнения!")
    private String director;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 50, message = "Размер КЭД не может быть больше 50")
    private String ked;
    private String email;
    private String emailPassword;
    @Size(max = 30, message = "Размер номера телефона не может быть больше 30")
    private String phone;
    private String esf;
    private String esfPassword;
    private String kkm;
    private String kkmPassword;
    private String fresh1c;
    private String fresh1cPassword;
    private String ettn;
    private String ettnPassword;
    private boolean isDeleted;
}
