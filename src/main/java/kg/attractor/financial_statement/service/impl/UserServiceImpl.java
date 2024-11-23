package kg.attractor.financial_statement.service.impl;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.UserPageableRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserCompanyService;
import kg.attractor.financial_statement.service.UserService;
import kg.attractor.financial_statement.utils.FileUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final UserPageableRepository userPageableRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;
    private CompanyService companyService;
    private UserCompanyService userCompanyService;

    @Autowired
    @Lazy
    private void setUserCompanyService(UserCompanyService userCompanyService) {
        this.userCompanyService = userCompanyService;
    }

    @Autowired
    @Lazy
    private void setCompanyService(CompanyService companyService) {
        this.companyService = companyService;
    }

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
                .avatar("user.png")
                .registerDate(LocalDate.now())
                .credentialsUpdated(true)
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
    public UserDetailsDto getUserDetailDto(Long userId) {
        UserDto userDto = getUserDtoById(userId);
        List<CompanyDto> companies = companyService.getAllCompanies();
        List<RoleDto> roles = roleService.getAll();
        return UserDetailsDto.builder()
                .user(userDto)
                .companies(companies)
                .roles(roles)
                .build();
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
    public void editUser(Long id, UserDto userDto) {
        User user = getUserById(id);
        if(user.isEnabled()){
            Role role = roleService.getRoleById(userDto.getRoleDto().getId());
            validateBirthday(userDto.getBirthday());
            user.setRole(role);
            user.setBirthday(userDto.getBirthday());
            user.setNotes(userDto.getNotes());
            if (!userDto.getName().isEmpty()) {
                user.setName(userDto.getName());
            }
            if (!userDto.getSurname().isEmpty()) {
                user.setSurname(userDto.getSurname());
            }
            List<Company> newCompanies = userDto.getCompanies().stream()
                    .map(companyDto -> companyService.getCompanyById(companyDto.getId()))
                    .toList();
            userCompanyService.updateUserCompanies(user, newCompanies);
            userRepository.save(user);
        } else {
            throw new IllegalArgumentException("Удаленного пользователя нельзя редактировать");
        }
    }

    private void updateLoginIfChanged(String newLogin, User user) {
        if (!Objects.equals(newLogin, user.getLogin())) {
            if (checkIfUserExists(newLogin)) {
                throw new IllegalArgumentException("Пользователь с таким логином уже существует");
            }
            user.setLogin(newLogin);
        }
    }

    @Override
    public void updateLoginAndPassword(Long userId, String newLogin, String newPassword) {
        validatePassword(newPassword);
        User user = getUserById(userId);
        updateLoginIfChanged(newLogin, user);
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setCredentialsUpdated(true);
        userRepository.save(user);
    }

    private void validatePassword(String password) {
        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("Заполните поля поролей");
        }
        if (password.length() < 8 || password.length() > 20) {
            throw new IllegalArgumentException("Пароль должен содержать минимум 8 символов и максимум 20 на латыни");
        }
        if (!password.matches("^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$")) {
            throw new IllegalArgumentException("Пароль должен содержать минимум 1 символ верхнего регистра, 1 символ нижнего регистра и минимум 1 символ");
        }
    }

    @Override
    public String updateAvatar(Long userId, MultipartFile file) throws IOException {
        User user = getUserById(userId);
        if(user.isEnabled()){
            validateImageType(file);
            String avatar = FileUtils.uploadFile(file);
            user.setAvatar(avatar);
            userRepository.save(user);
            return avatar;
        } else {
            throw new IllegalArgumentException("Удаленного пользователя нельзя редактировать");
        }

    }

    private void validateImageType(MultipartFile file) {
        String contentType = file.getContentType();
        if (contentType == null ||
                !(contentType.equals("image/jpeg") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/webp") ||
                        contentType.equals("image/png"))) {
            throw new IllegalArgumentException("Invalid image type: " + contentType);
        }
    }

    @Override
    public void deleteUser(Long id) {
        User user = getUserById(id);
        if (user.getRole().getRoleName().equals("SuperUser")) {
            throw new IllegalArgumentException("Нельзя удалить администратора системы");
        }
        user.setRole(null);
        user.setEnabled(false);
        userRepository.save(user);
    }

    @Override
    public Page<UserDto> getAllDtoUsers(Pageable pageable) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User currentUser = getUserByLogin(auth.getName());
        Page<User> users = userPageableRepository.findAllByOrderByEnabledDesc(pageable);
        boolean isCurrentUserSuperUser = currentUser.getRole().getRoleName().equals("SuperUser");
        var list = users.get()
                .filter(user -> isCurrentUserSuperUser || user.getRole() == null || !"SuperUser".equals(user.getRole().getRoleName()))
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
                .map(userCompanyService::convertToCompanyToCompanyDto)
                .toList();
    }

    @Override
    public UserDto getUserDtoByCookie(HttpServletRequest request) {
        try {
            Cookie[] cookies = request.getCookies();
            UserDto userDto = new UserDto();
            if (cookies != null) {
                userDto = Arrays.stream(cookies)
                        .filter(cookie -> "username".equals(cookie.getName()))
                        .map(Cookie::getValue)
                        .findFirst()
                        .map(username -> {
                            try {
                                return getUserDtoByLogin(username);
                            } catch (UsernameNotFoundException e) {
                                System.out.println("User not found: " + username);
                                return null;
                            }
                        })
                        .orElse(null);
            }
            return userDto;
        } catch (Exception e) {
            System.err.println("Exception occurred in getUserDtoByCookie: " + e.getMessage());
            return null;
        }
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
                return userDto.getRoleDto().getAuthorities().stream()
                        .anyMatch(authorityDto -> authorityDto.getAuthority().equalsIgnoreCase("DELETE_COMPANY"));
            }
        }
        return false;
    }

    private List<UserDto> convertToDtoList(List<User> users) {
        return users.stream().map(this::convertToUserDto).collect(Collectors.toList());
    }

    @Override
    public UserDto convertToUserDto(User user) {
        RoleDto roleDto = (user.getRole() != null) ? roleService.convertToDto(user.getRole()) : null;
        return UserDto
                .builder()
                .id(user.getId())
                .name(user.getName())
                .surname(user.getSurname())
                .login(user.getLogin())
                .password(user.getPassword())
                .birthday(user.getBirthday())
                .enabled(user.isEnabled())
                .notes(user.getNotes())
                .registerDate(user.getRegisterDate())
                .avatar(user.getAvatar())
                .roleDto(roleDto)
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
