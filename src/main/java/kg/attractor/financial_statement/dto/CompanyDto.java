package kg.attractor.financial_statement.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import kg.attractor.financial_statement.validation.*;
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
    @UniqueCompanyName
    private String name;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(min = 12,max = 12, message = "Длина ИНН компании должна состоять из 12 символов")
    @UniqueCompanyInn
    private String companyInn;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(min = 12,max = 12, message = "Длина ИНН директора должна состоять из 12 символов")
    @UniqueCompanyDirectorInn
    private String directorInn;
    @NotBlank(message = "Обязательно для заполнения!")
    @UniqueCompanyLogin
    private String login;
    @NotBlank(message = "Обязательно для заполнения!")
    private String password;
    @NotBlank(message = "Обязательно для заполнения!")
    private String ecp;
    @NotBlank(message = "Обязательно для заполнения!")
    @UniqueCompanySalykLogin
    private String kabinetSalyk;
    @NotBlank(message = "Обязательно для заполнения!")
    private String kabinetSalykPassword;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 75, message = "Размер налогооблажения не должен превышать 75 символов")
    private String taxMode;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 75, message = "Размер ОПФ не должен превышать 75 символов")
    private String opf;
    @NotBlank(message = "Обязательно для заполнения!")
    private String districtGns;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(min = 12,max = 12, message = "Номер социального фонда должен состоять из 12 символов")
    private String socfundNumber;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 50, message = "Размер регистрационного номера МЮ не должен превышать 50 символов")
    private String registrationNumberMj;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(min = 8,max = 8, message = "Код ОКПО должен состоять 8 из символов")
    private String okpo;
    @NotBlank(message = "Обязательно для заполнения!")
    private String director;
    @NotBlank(message = "Обязательно для заполнения!")
    @Size(max = 50, message = "Размер КЭД не должен превышать 50 символов")
    private String ked;
    private String email;
    private String emailPassword;
    @Size(max = 30, message = "Длина номера телефона не должна превышать 30 символов")
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

    private String reportFrequency;
}
