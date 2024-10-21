package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.userdetails.UserCache;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String surname;
    private String login;
    private String password;
    private boolean enabled;
    private LocalDate birthday;

    @ManyToMany(fetch = FetchType.EAGER, mappedBy = "users", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private Collection<Role> roles = new ArrayList<>();

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<UserCompany> userCompanies;
}
