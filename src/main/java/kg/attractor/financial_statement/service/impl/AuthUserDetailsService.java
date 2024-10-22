package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import java.util.Collection;
import java.util.List;

@RequiredArgsConstructor
@Component

public class AuthUserDetailsService implements UserDetailsService {
    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String login) throws UsernameNotFoundException {
        User user = userRepository.findByLogin(login)
                .orElseThrow(() -> new UsernameNotFoundException("user with login " + login + "not found"));
        return new org.springframework.security.core.userdetails.User(
                user.getLogin(),
                user.getPassword(),
                user.isEnabled(),
                true,
                true,
                true,
                getAuthorities(login)
        );
    }


    public Collection<? extends GrantedAuthority> getAuthorities(String login) {
        User user = userRepository.findByLogin(login)
                .orElseThrow(() -> new UsernameNotFoundException("user with login " + login + "not found"));
        return List.of(new SimpleGrantedAuthority(user.getRole().getRoleName()));
    }
}
