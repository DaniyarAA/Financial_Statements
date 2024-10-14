package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.UserForTaskDto;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    @Override
    public UserForTaskDto getUserForTaskDto(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User not found with id " + id));
        return convertToForTaskDto(user);
    }

    private UserForTaskDto convertToForTaskDto(User user) {
        return UserForTaskDto.builder()
                .name(user.getName())
                .surname(user.getSurname())
                .login(user.getLogin())
                .build();
    }
}
