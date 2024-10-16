package kg.attractor.financial_statement.dto;

import jakarta.validation.constraints.NotBlank;
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
    @NotBlank(message = "Обезателно для запонения !")
    private String name;
    @NotBlank(message = "Обезателно для запонения !")
    private String inn;
    @NotBlank(message = "Обезателно для запонения !")
    private String directorInn;
    @NotBlank(message = "Обезателно для запонения !")
    private String login;
    @NotBlank(message = "Обезателно для запонения !")
    private String password;
    @NotBlank(message = "Обезателно для запонения !")
    private String ecp;
    @NotBlank(message = "Обезателно для запонения !")
    private String kabinetSalyk;
    @NotBlank(message = "Обезателно для запонения !")
    private String kabinetSalykPassword;
    @NotBlank(message = "Обезателно для запонения !")
    private String taxMode;
    @NotBlank(message = "Обезателно для запонения !")
    private String opf;
    @NotBlank(message = "Обезателно для запонения !")
    private String districtGns;
    @NotBlank(message = "Обезателно для запонения !")
    private String socfundNumber;
    @NotBlank(message = "Обезателно для запонения !")
    private String registrationNumberMj;
    @NotBlank(message = "Обезателно для запонения !")
    private String okpo;
    @NotBlank(message = "Обезателно для запонения !")
    private String director;
    @NotBlank(message = "Обезателно для запонения !")
    private String ked;
    private String email;
    private String emailPassword;
    private String phone;
    private String esf;
    private String esfPassword;
    private String kkm;
    private String kkmPassword;
    private String fresh1c;
    private String fresh1cPassword;
    private String ettn;
    private String ettnPassword;
}
