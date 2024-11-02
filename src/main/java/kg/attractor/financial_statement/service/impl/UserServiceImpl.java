package kg.attractor.financial_statement.service.impl;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserService;
import kg.attractor.financial_statement.utils.FileUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

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
        validateBirthday(userDto.getBirthday());
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

    private void validateBirthday(LocalDate birthday) {
        if (birthday.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Человек еще не родился");
        } else if (birthday.isAfter(LocalDate.now().minusYears(18))) {
            throw new IllegalArgumentException("Человеку должно быть больше 18 лет");
        }
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
    public void updateUser(Long id, EditUserDto userDto) throws IOException {
        if (!validateImageType(userDto.getAvatar())) {
            throw new IOException("Неподдерживаемый формат файла. Поддерживаются только jpg, jpeg, webp и png.");
        }
        validateBirthday(userDto.getBirthday());
        User user = getUserById(id);
        String avatar = FileUtils.uploadFile(userDto.getAvatar());
        user.setName(userDto.getName());
        user.setSurname(userDto.getSurname());
        user.setLogin(userDto.getLogin());
        user.setAvatar(avatar);
        user.setBirthday(userDto.getBirthday());
        user.setRole(roleService.getRoleById(userDto.getRoleDto().getId()));
        userRepository.save(user);
    }

    private boolean validateImageType(MultipartFile file) {
        String contentType = file.getContentType();
        return contentType != null &&
                (contentType.equals("image/jpeg")
                        || contentType.equals("image/jpg")
                        || contentType.equals("image/webp")
                        || contentType.equals("image/png"));
    }

    @Override
    public void deleteUser(Long id) {
        User user = getUserById(id);
        user.setEnabled(false);
        userRepository.save(user);
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

    @Override
    public UserDto getUserDtoByCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        UserDto userDto = new UserDto();
        if (cookies != null) {
            userDto = Arrays.stream(cookies).sequential()
                    .filter(cookie -> "username".equals(cookie.getName()))
                    .map(Cookie::getValue)
                    .findFirst()
                    .map(this::getUserDtoByLogin)
                    .orElse(null);
        }
        return userDto;
    }

    @Override
    public List<UserDto> getAllUsers() {
        return convertToDtoList(userRepository.findAll());
    }

    @Override
    public UserForTaskDto getUserForTaskDto(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User not found for id: " + id));
        return convertToUserForTaskDto(user);
    }

    @Override
    public User getUserByLogin(String userLogin) {
        return userRepository.findByLogin(userLogin)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    @Override
    public Boolean isAdmin(String name) {
        if (!name.isBlank()) {
            UserDto userDto = getUserDtoByLogin(name);
            if (userDto != null && userDto.getRoleDto() != null) {
                return userDto.getRoleDto().getRoleName().equalsIgnoreCase("Админ");
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    private List<UserDto> convertToDtoList(List<User> users) {
        return users.stream().map(this::convertToUserDto).collect(Collectors.toList());
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
                .avatar(user.getAvatar())
                .roleDto(roleService.convertToDto(user.getRole()))
                .companies(getCompaniesByUserId(user.getId()))
                .build();
    }

    private UserForTaskDto convertToUserForTaskDto(User user) {
        return UserForTaskDto.builder()
                .login(user.getLogin())
                .name(user.getName())
                .surname(user.getSurname())
                .build();
    }

}
