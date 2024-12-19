package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import kg.attractor.financial_statement.enums.ReportFrequency;
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
    private String name;
    private String inn;
    private String directorInn;
    private String login;
    private String password;
    private String ecp;
    private String kabinetSalyk;
    private String kabinetSalykPassword;
    private String taxMode;
    private String opf;
    private String districtGns;
    private String socfundNumber;
    private String registrationNumberMj;
    private String okpo;
    private String director;
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

    private boolean isDeleted;

    @Enumerated(EnumType.STRING)
    private ReportFrequency reportFrequency;

}
