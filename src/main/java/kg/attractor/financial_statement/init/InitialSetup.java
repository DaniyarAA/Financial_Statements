package kg.attractor.financial_statement.init;

import jakarta.annotation.PostConstruct;
import kg.attractor.financial_statement.entity.Authority;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.AuthorityRepository;
import kg.attractor.financial_statement.repository.RoleRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;

@Component
@RequiredArgsConstructor
public class InitialSetup {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final AuthorityRepository authorityRepository;
    private final PasswordEncoder passwordEncoder;

    @PostConstruct
    public void setup() {
        List<Authority> authorities = authorityRepository.findAll();
        Role existingSuperUserRole = roleRepository.findByRoleName("SuperUser").orElse(null);

        if (existingSuperUserRole == null) {
            Role superUserRole = new Role();
            superUserRole.setRoleName("SuperUser");
            superUserRole.setAuthorities(authorities);
            superUserRole.getAuthorities().addAll(authorities);
            authorities.forEach(authority -> authority.getRoles().add(superUserRole));
            roleRepository.save(superUserRole);

            if (!userRepository.existsByLogin("admin")) {
                User admin = new User();
                admin.setName("Admin");
                admin.setSurname("Admin");
                admin.setLogin("admin");
                admin.setPassword(passwordEncoder.encode("admin"));
                admin.setEnabled(true);
                admin.setBirthday(LocalDate.of(1999, 1, 1));
                admin.setRegisterDate(LocalDate.now());
                admin.setAvatar("data/files/user.png");
                admin.setRole(existingSuperUserRole != null ? existingSuperUserRole : superUserRole);
                userRepository.save(admin);
            }
        }
    }
}