package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;


    @Override
    public void registerUser(UserDto userDto) {
        User newUser = User.builder()
                .name(userDto.getName())
                .surname(userDto.getSurname())
                .login(userDto.getLogin())
                .password(passwordEncoder.encode(userDto.getPassword()))
                .enabled(true)
                .birthday(userDto.getBirthday())
                .role(roleService.getRoleById(userDto.getRoleId()))
                .avatar("static/user.png")
                .registerDate(LocalDate.now())
                .build();
        userRepository.save(newUser);

    }

    @Override
    public UserDto getUserDtoById(Long id) {
        User user = getUserById(id);
        return convertToUserDto(user);
    }


    @Override
    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    @Override
    public UserDto getUserDtoByLogin(String login) {
        User user = userRepository.findByLogin(login)
                .orElseThrow(() -> new UsernameNotFoundException("user not found"));
        return convertToUserDto(user);
    }

    @Override
    public void updateUser(Long id, EditUserDto userDto) {
        User user = userRepository.findById(id).orElseThrow(() ->
                new UsernameNotFoundException("User not found"));
        user.setName(userDto.getName());
        user.setSurname(userDto.getSurname());
        user.setLogin(userDto.getLogin());
        user.setBirthday(userDto.getBirthday());
        userRepository.save(user);
    }

    @Override
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public List<UserDto> getAllDtoUsers() {
        List<User> users = userRepository.findAll();
        List<UserDto> userDto = new ArrayList<>();

        for (User user : users) {
            userDto.add(convertToUserDto(user));
        }
        userDto.sort(Comparator.comparing(UserDto::getId));

        return userDto;
    }

    @Override
    public boolean checkIfUserExists(String login) {
        return userRepository.findByLogin(login).isPresent();
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
                .registerDate(user.getRegisterDate())
                .avatar("static/user.png")
                .roleId(user.getRole().getId())
                .roleDto(convertToRole(roleService.getRoleById(user.getRole().getId())))
               // .userCompanyDtoList(getCompanyListByUserDtoId(user.getId()))
                .build();
    }

    private RoleDto convertToRole(Role role) {
        return RoleDto.builder()
                .id(role.getId())
                .roleName(role.getRoleName())
                .build();
    }

}
