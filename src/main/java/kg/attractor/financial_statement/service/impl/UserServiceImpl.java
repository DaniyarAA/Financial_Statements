package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;
    private final CompanyService companyService;


    @Override
    public void registerUser(UserDto userDto) {
        User newUser = User.builder()
                .name(userDto.getName())
                .surname(userDto.getSurname())
                .login(userDto.getLogin())
                .password(passwordEncoder.encode(userDto.getPassword()))
                .enabled(true)
                .birthday(userDto.getBirthday())
                .role(roleService.getRoleById(userDto.getRoleDto().getId()))
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
        User user = getUserById(id);
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
    public Page<UserDto> getAllDtoUsers(Pageable pageable) {
      Page<User> users = userRepository.findAll(pageable);
      var list = users.get()
              .map(this::convertToUserDto)
              .toList();
      return new PageImpl<>(list, pageable, users.getTotalElements());
    }

    @Override
    public boolean checkIfUserExists(String login) {
        return userRepository.findByLogin(login).isPresent();
    }

    private List<CompanyDto> getCompaniesByUserId(Long userId) {
        User user = getUserById(userId);
        return user.getUserCompanies().stream()
                .map(UserCompany::getCompany)
                .map(companyService::convertToDto)
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
                .registerDate(user.getRegisterDate())
                .avatar("static/user.png")
                .roleDto(roleService.convertToDto(user.getRole()))
                .companies(getCompaniesByUserId(user.getId()))
                .build();
    }

}
