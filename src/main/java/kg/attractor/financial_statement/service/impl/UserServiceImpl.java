package kg.attractor.financial_statement.service.impl;

import jakarta.mail.MessagingException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.UserPageableRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserService;
import kg.attractor.financial_statement.utils.FileUtils;
import kg.attractor.financial_statement.utils.Utilities;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.time.LocalDate;
import java.time.Period;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final UserPageableRepository userPageableRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;
    private final CompanyService companyService;
    private final EmailService emailService;

    @Autowired
    public UserServiceImpl(
            UserRepository userRepository,
            UserPageableRepository userPageableRepository,
            PasswordEncoder passwordEncoder,
            RoleService roleService,
            @Lazy CompanyService companyService,
            EmailService emailService
    ) {
        this.userRepository = userRepository;
        this.userPageableRepository = userPageableRepository;
        this.passwordEncoder = passwordEncoder;
        this.roleService = roleService;
        this.companyService = companyService;
        this.emailService = emailService;
    }

    @Override
    public Boolean messageIsSuccessfullySent(Map<String, Object> answer){
        return answer.get("message").toString().equalsIgnoreCase("Успешно");
    }

    @Override
    public Map<String, Object> sendMessageToUser(HttpServletRequest request) {
        Map<String, Object> model = new HashMap<>();
        try {
            makeMessageForUser(request);
            model.put("message", "Успешно");
        } catch (UsernameNotFoundException | UnsupportedEncodingException e) {
            model.put("error", e.getMessage());
        } catch (MessagingException e) {
            model.put("error", "Ошибка при отправке сообщения на почту !");
        }
        return model;
    }

    private void makeMessageForUser(HttpServletRequest request) throws MessagingException, UnsupportedEncodingException {
        String email = request.getParameter("email");
        String login = request.getParameter("login");
        String adminText = request.getParameter("adminText");
        String password = request.getParameter("password");
        String userName = request.getParameter("userName");
        String link = Utilities.getSiteUrl(request) + "/login";
        emailService.sendMail(email,login,adminText,password, link,userName);
    }

    @Override
    public Long registerUser(UserDto userDto) {
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
                .email(userDto.getEmail())
                .build();
        log.info("registering User: {} in process...", newUser);
        userRepository.save(newUser);
        return newUser.getId();

    }


    @Override
    public UserDto getUserDtoById(Long id) {
        User user = getUserById(id);
        log.info("get user by id {}", id);
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
        if(!user.isEnabled()){
            throw new IllegalArgumentException("Удаленного пользователя нельзя редактировать!");
        }
        validateUserDto(userDto);
        updateEmailIfChanged(userDto.getEmail(), user);
        if(!user.getRole().getRoleName().equals("SuperUser")){
            Role role = roleService.getRoleById(userDto.getRoleDto().getId());
            user.setRole(role);
        }
        user.setBirthday(userDto.getBirthday());
        user.setNotes(userDto.getNotes());
        user.setName(userDto.getName());
        user.setSurname(userDto.getSurname());
        List<Company> selectedCompanies = companyService.findAllById(userDto.getCompanyIds());
        for(Company company : selectedCompanies){
            if(!user.getCompanies().contains(company)){
                user.getCompanies().add(company);
                company.getUsers().add(user);
            }
        }
        Iterator<Company> iterator = user.getCompanies().iterator();
        while (iterator.hasNext()) {
            Company company = iterator.next();
            if (!selectedCompanies.contains(company)) {
                iterator.remove();
                company.getUsers().remove(user);
            }
        }


        log.info("edit user {}in process...", user.getLogin());
        userRepository.save(user);


    }


    private void validateUserDto(UserDto userDto) {
        if (userDto.getBirthday() == null) {
            throw new IllegalArgumentException("Заполните дату рождения!");
        }
        validateBirthday(userDto.getBirthday());

        if (isNullOrEmpty(userDto.getName()) || isNullOrEmpty(userDto.getSurname())) {
            throw new IllegalArgumentException("Заполните имя и фамилию!");
        }
    }

    private boolean isNullOrEmpty(String str) {
        return str == null || str.isEmpty();
    }

    private void validateBirthday(LocalDate birthday) {
        LocalDate now = LocalDate.now();
        if (birthday.isAfter(now)) {
            String message = "Дата рождения указана неверно: сотрудник еще не родился";
            log.info(message);
            throw new IllegalArgumentException(message);
        }
        int age = Period.between(birthday, now).getYears();
        if (age < 18) {
            String message = "Возраст сотрудника должен быть не менее 18 лет для трудоустройства";
            log.info(message);
            throw new IllegalArgumentException(message);
        } else if (age > 100) {
            String message = "Возраст сотрудника не должен превышать 100 лет";
            log.info(message);
            throw new IllegalArgumentException(message);
        }
    }

    private void updateLoginIfChanged(String newLogin, User user) {
        if (!Objects.equals(newLogin, user.getLogin())) {
            log.info("Проверка уникальности логина: {}", newLogin);
            if (checkIfUserExistsByLogin(newLogin)) {
                log.error("Пользователь с логином {} уже существует", newLogin);
                throw new IllegalArgumentException("Пользователь с таким логином уже существует");
            }
            if (newLogin.isBlank()) {
                throw new IllegalArgumentException("Заполните пожалуйста логин!");
            }
            log.info("Обновление логина для пользователя: {}", newLogin);
            user.setLogin(newLogin);
        }
    }

    private void updateEmailIfChanged(String newEmail, User user) {
        if(newEmail == null || newEmail.isEmpty()){
            throw new IllegalArgumentException("Заполните почту!");
        }
        if (!Objects.equals(newEmail, user.getEmail())) {
            if (checkIfUserExistsByEmail(newEmail)) {
                log.info("Пользователь с такой почтой уже существует");
                throw new IllegalArgumentException("Пользователь с такой почтой уже существует");
            }
            log.info("changed email for user");
            user.setEmail(newEmail);
        }
    }

    @Override
    public void updateLoginAndPassword(Long userId, String newLogin, String newPassword) {
        validatePassword(newPassword);
        User user = getUserById(userId);
        updateLoginIfChanged(newLogin, user);
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setCredentialsUpdated(true);
        log.info("changed login and password for user - {} successfully", user.getLogin());
        userRepository.save(user);
    }

    private void validatePassword(String password) {
        if (password == null || password.isBlank()) {
            log.info("password is null");
            throw new IllegalArgumentException("Заполните поля поролей");
        }
        if (password.length() < 8 || password.length() > 20) {
            log.info("length of password is less than 8 or more than 20");
            throw new IllegalArgumentException("Пароль должен содержать минимум 8 символов и максимум 20 на латыни");
        }
        if (!password.matches("^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$")) {
            log.info("The password have not any letter at least 1 uppercase letter, at least 1 lowercase letter in latin");
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
            log.info("changing avatar for user - {} in process", user.getLogin());
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
        if(user.isEnabled()){
            if (user.getRole().getRoleName().equals("SuperUser")) {
                log.info("Нельзя удалить администратора системы");
                throw new IllegalArgumentException("Нельзя удалить администратора системы");
            }
            log.info("deleting user - {} in process...", user.getLogin());
            user.setRole(null);
            user.setEnabled(false);
            for(Company company : user.getCompanies()){
                company.getUsers().remove(user);
            }
            user.getCompanies().clear();
//            userCompanyService.updateUserCompaniesOnUserDeletion(id);
            userRepository.save(user);
        }
    }

    @Override
    public Page<UserDto> getAllDtoUsers(Pageable pageable, String login) {
        User currentUser = getUserByLogin(login);
        boolean isCurrentUserSuperUser = currentUser.getRole().getRoleName().equals("SuperUser");
        Page<User> users;
        if (isCurrentUserSuperUser) {
            users = userPageableRepository.findAllByOrderByEnabledDescIdAsc(pageable);
        } else {
            users = userPageableRepository.findAllByRole_RoleNameNotOrRoleIsNullOrderByEnabledDescIdAsc("SuperUser", pageable);
        }
        var list = users.stream()
                .map(this::convertToUserDto)
                .toList();
        int startIndex = pageable.getPageNumber() * pageable.getPageSize();
        for (int i = 0; i < list.size(); i++) {
            list.get(i).setDisplayIndex(startIndex + i + 1);
        }
        return new PageImpl<>(list, pageable, users.getTotalElements());
    }

    @Override
    public boolean checkIfUserExistsByLogin(String login) {
        return userRepository.findByLogin(login).isPresent();
    }

    @Override
    public boolean checkIfUserExistsByEmail(String email) {
        return userRepository.findByEmail(email).isPresent();
    }

    private List<CompanyDto> getCompaniesByUserId(Long userId) {
        User user = getUserById(userId);

        return user.getCompanies().stream()
                .map(companyService::convertToDto)
                .toList();
    }

    @Override
    public UserDto getUserDtoByCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            Optional<String> usernameOpt = Arrays.stream(cookies)
                    .filter(cookie -> "username".equals(cookie.getName()))
                    .map(Cookie::getValue)
                    .findFirst();

            if (usernameOpt.isPresent()) {
                String username = usernameOpt.get();
                try {
                    return getUserDtoByLogin(username);
                } catch (UsernameNotFoundException e) {
                    log.info("Пользователь с логином '{}' не найден, удаляем куку.", username);
                    return null;
                }
            }
        }
        return null;
    }


    @Override
    public List<UserDto> getAllUsers() {
        return convertToDtoList(userRepository.findAll());
    }

    @Override
    public UserForTaskDto getUserForTaskDto(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("User not found for id: " + id));
        return convertToUserForTaskDto(user);
    }
    @Override
    public UserForTaskDto getUserForTaskDto(User user) {
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
                .email(user.getEmail())
                .companies(getCompaniesByUserId(user.getId()))
                .credentialsUpdated(user.isCredentialsUpdated())
                .build();
    }

    private UserForTaskDto convertToUserForTaskDto(User user) {
        return UserForTaskDto.builder()
                .login(user.getLogin())
                .name(user.getName())
                .surname(user.getSurname())
                .build();
    }

    @Override
    public List<UserDto> getDeletedUsers() {
        return convertToDtoList(userRepository.findAllByEnabledIsFalse());
    }

    @Override
    public void resumeUser(Long id, Long roleId) {
        User user = getUserById(id);
        log.info("resume user - {} in process...", user.getLogin());
        user.setRole(roleService.getRoleById(roleId));
        user.setEnabled(true);
        userRepository.save(user);
    }

    @Override
    public boolean canEdit(String name) {
        if (!name.isBlank()) {
            UserDto userDto = getUserDtoByLogin(name);
            if (userDto != null && userDto.getRoleDto() != null) {
                return userDto.getRoleDto().getAuthorities().stream()
                        .anyMatch(authorityDto -> authorityDto.getAuthority().equalsIgnoreCase("EDIT_COMPANY"));
            }
        }
        return false;
    }

    @Override
    public boolean canCreate(String name) {
        if (!name.isBlank()) {
            UserDto userDto = getUserDtoByLogin(name);
            if (userDto != null && userDto.getRoleDto() != null) {
                return userDto.getRoleDto().getAuthorities().stream()
                        .anyMatch(authorityDto -> authorityDto.getAuthority().equalsIgnoreCase("CREATE_COMPANY"));
            }
        }
        return false;
    }

    @Override
    public boolean canReturn(String name) {
        if (!name.isBlank()) {
            UserDto userDto = getUserDtoByLogin(name);
            if (userDto != null && userDto.getRoleDto() != null) {
                return userDto.getRoleDto().getAuthorities().stream()
                        .anyMatch(authorityDto -> authorityDto.getAuthority().equalsIgnoreCase("CREATE_COMPANY"));//TODO: сделать на RETURN_COMPANY сейчас его нет
            }
        }
        return false;
    }

    @Override
    public boolean canViewCompany(String name) {
        if (!name.isBlank()) {
            UserDto userDto = getUserDtoByLogin(name);
            if (userDto != null && userDto.getRoleDto() != null) {
                return userDto.getRoleDto().getAuthorities().stream()
                        .anyMatch(authorityDto -> authorityDto.getAuthority().equalsIgnoreCase("VIEW_COMPANY"));
            }
        }
        return false;
    }

}
