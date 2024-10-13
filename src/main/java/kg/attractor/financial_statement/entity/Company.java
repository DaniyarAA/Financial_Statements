package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "companies")
public class Company {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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
    @Column(name = "fresh_1c")
    private String fresh1c;
    @Column(name = "fresh_1c_password")
    private String fresh1cPassword;
    private String ettn;
    private String ettnPassword;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "company")
    private List<Task> tasks;
}
