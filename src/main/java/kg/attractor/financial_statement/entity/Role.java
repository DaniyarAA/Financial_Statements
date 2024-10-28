package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.Collection;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "role")
    private String roleName;

    @ManyToMany(fetch = FetchType.EAGER, mappedBy = "roles", cascade = CascadeType.ALL)
    private Collection<Authority> authorities;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "role")
    private List<User> users;
}
