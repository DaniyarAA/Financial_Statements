package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.RoleRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;


    @Override
    public void registerUser(UserDto userDto) {
        User newUser = User.builder()
                .name(userDto.getName())
                .surname(userDto.getSurname())
                .login(userDto.getLogin())
                .password(passwordEncoder.encode(userDto.getPassword()))
                // .avatar("static/user.png")
                .enabled(true)
                // .registrationDate(userDto.getRegistrationDate())
                // .isActive(userDto.isActive())
                .birthday(userDto.getBirthday())
                .roles(new ArrayList<>())
                .build();
        Role role = roleRepository.findById(userDto.getRoleId())
                .orElseThrow();
        newUser.getRoles().add(role);
        role.getUsers().add(newUser);
        userRepository.save(newUser);

    }

    @Override
    public UserDto getUserById(Long id) {
        return userRepository.findById(id)
                .stream()
                .map(this::convertToUserDto)
                .findFirst()
                .orElseThrow(() -> new UsernameNotFoundException("user not found"));
    }

    @Override
    public UserDto getUserByLogin(String login) {
        return userRepository.findByLogin(login)
                .stream()
                .map(this::convertToUserDto)
                .findFirst()
                .orElseThrow(() -> new UsernameNotFoundException("user not found"));
    }

    @Override
    public void updateUser(UserDto userDto) {
        User user = userRepository.findById(userDto.getId()).orElseThrow();
        user.setName(userDto.getName());
        user.setSurname(userDto.getSurname());
        user.setLogin(userDto.getLogin());
        user.setBirthday(userDto.getBirthday());
//        user.setRoles(new ArrayList<>());
//        roleRepository.findById()TODO логика для выбора ролей и присвоения юзеру
        //TODO user.setAvatar(userDto.getAvatar());
        //TODO user.setIsActive(userDto.isActive());
        userRepository.save(user);
    }

    @Override
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public List<UserDto> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(this::convertToUserDto)
                .toList();
    }

    private UserDto convertToUserDto(User user) {
        return UserDto
                .builder()
                .id(user.getId())
                .name(user.getName())
                .surname(user.getSurname())
                .login(user.getLogin())
                .password(user.getPassword())
                .birthday(user.getBirthday())
                .enabled(user.isEnabled())
                .registrationDate(LocalDate.now())
                //.avatar("static/user.png")
                //.roleId(user.getRoles())
                //.roles/.registerDate/.avatar/.
                .build();
    }
}