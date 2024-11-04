package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserPrivateService {
    private final UserRepository userRepository;

    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    public User getUserByLogin(String userLogin) {
        return userRepository.findByLogin(userLogin)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }
}
