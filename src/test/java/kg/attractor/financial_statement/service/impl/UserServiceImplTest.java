package kg.attractor.financial_statement.service.impl;

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
import kg.attractor.financial_statement.utils.FileUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserServiceImplTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserCompanyService userCompanyService;

    @Mock
    private CompanyService companyService;

    @Mock
    private UserPageableRepository userPageableRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private RoleService roleService;

    @Spy
    @InjectMocks
    private UserServiceImpl userService;

    private User existingUser;
    private UserCompany existingUserCompany;

    @BeforeEach
    void setUp() {
        existingUserCompany = new UserCompany();
        existingUserCompany.setCompany(new Company());
        existingUser = new User();
        existingUser.setId(1L);
        existingUser.setName("Шерлок");
        existingUser.setSurname("Холмс");
        existingUser.setLogin("Shelli");
        existingUser.setPassword("Sher_lock123");
        existingUser.setEnabled(true);
        existingUser.setBirthday(LocalDate.of(1990, 1, 1));
        existingUser.setRegisterDate(LocalDate.now());
        existingUser.setAvatar("user.png");
        existingUser.setUserCompanies(new ArrayList<>());
        existingUser.getUserCompanies().add(existingUserCompany);
        Role userRole = new Role();
        userRole.setId(1L);
        userRole.setRoleName("User");
        existingUser.setRole(userRole);
    }

    @Test
    void testRegisterUser_Success() {
        RoleDto roleDto = RoleDto.builder().id(1L).roleName("Test").build();
        Role role = new Role();
        role.setId(1L);
        role.setRoleName("Test");
        UserDto userDto = UserDto.builder()
                .name("Том")
                .surname("Харди")
                .login("Venom")
                .password("Wearevenom123")
                .birthday(LocalDate.now().minusYears(20))
                .registerDate(LocalDate.now())
                .roleDto(roleDto)
                .build();
        when(roleService.getRoleById(1L)).thenReturn(role);
        when(passwordEncoder.encode(userDto.getPassword())).thenReturn("encoded_password");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));


        userService.registerUser(userDto);

        verify(userRepository).save(any(User.class));
    }

    @Test
    void testRegisterUser_ThrowsExceptionIfUnderage() {
        UserDto userDto = new UserDto();
        userDto.setBirthday(LocalDate.now().minusYears(17));

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.registerUser(userDto));
        assertEquals("Человеку должно быть больше 18 лет", exception.getMessage());
    }


    @Test
    void testRegisterUser_BirthdayInFuture_ThrowsException() {
        UserDto userDto = new UserDto();
        userDto.setBirthday(LocalDate.now().plusDays(1));

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.registerUser(userDto));
        assertEquals("Человек еще не родился", exception.getMessage());
    }


    @Test
    void testGetUserDtoById_UserExists_ReturnsUserDto() {
        Long userId = 1L;
        UserDto mockUserDto = mock(UserDto.class);
        doReturn(existingUser).when(userService).getUserById(userId);
        doReturn(mockUserDto).when(userService).convertToUserDto(existingUser);

        UserDto result = userService.getUserDtoById(userId);

        assertNotNull(result);
        assertEquals(mockUserDto, result);
        verify(userService).getUserById(userId);
        verify(userService).convertToUserDto(existingUser);
    }

    @Test
    void getUserDtoById_UserNotFound_ThrowsException() {
        Long userId = 1L;

        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        UsernameNotFoundException exception = assertThrows(UsernameNotFoundException.class, () -> userService.getUserDtoById(userId));
        assertEquals("User not found", exception.getMessage());
    }


    @Test
    void testGetUserDetailDto_UserExists_ReturnsUserDetailsDto() {
        Long userId = 1L;

        UserDto userDto = UserDto.builder()
                .id(userId)
                .name("Тестовый")
                .surname("Пользователь")
                .build();

        List<CompanyDto> companies = new ArrayList<>();
        companies.add(CompanyDto.builder().id(1L).name("Компания 1").build());
        companies.add(CompanyDto.builder().id(2L).name("Компания 2").build());

        List<RoleDto> roles = new ArrayList<>();
        roles.add(RoleDto.builder().id(1L).roleName("Роль 1").build());
        roles.add(RoleDto.builder().id(2L).roleName("Роль 2").build());

        doReturn(userDto).when(userService).getUserDtoById(userId);

        when(companyService.getAllCompanies()).thenReturn(companies);
        when(roleService.getAll()).thenReturn(roles);

        UserDetailsDto result = userService.getUserDetailDto(userId);

        assertNotNull(result);
        assertEquals(userDto, result.getUser());
        assertEquals(companies, result.getCompanies());
        assertEquals(roles, result.getRoles());

        verify(userService).getUserDtoById(userId);
        verify(companyService).getAllCompanies();
        verify(roleService).getAll();
    }


    @Test
    void testUpdateAvatar_Success() throws IOException {
        MultipartFile mockFile = mock(MultipartFile.class);
        String expectedPath = "path/to/avatar.jpg";

        when(mockFile.getContentType()).thenReturn("image/jpeg");
        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));

        try (MockedStatic<FileUtils> mockedFileUtils = Mockito.mockStatic(FileUtils.class)) {
            mockedFileUtils.when(() -> FileUtils.uploadFile(mockFile)).thenReturn(expectedPath);
            String result = userService.updateAvatar(1L, mockFile);

            assertEquals(expectedPath, result);
            assertEquals(expectedPath, existingUser.getAvatar());
            verify(userRepository).save(existingUser);
            mockedFileUtils.verify(() -> FileUtils.uploadFile(mockFile), times(1));
        }
    }



    @Test
    void testUpdateAvatar_UserNotEnabled_ThrowsException() {
        existingUser.setEnabled(false);

        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));
        MultipartFile mockFile = mock(MultipartFile.class);

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> userService.updateAvatar(1L, mockFile));

        assertEquals("Удаленного пользователя нельзя редактировать", exception.getMessage());
    }



    @Test
    void testUpdateAvatar_InvalidFileType_ThrowsException() {
        MultipartFile mockFile = mock(MultipartFile.class);
        when(mockFile.getContentType()).thenReturn("application/pdf");

        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.updateAvatar(1L, mockFile));
        assertEquals("Invalid image type: application/pdf", exception.getMessage());
    }



    @Test
    void testGetAllDtoUsers_FiltrationSuperUser() {
        Pageable pageable = PageRequest.of(0, 10);
        String login = "super_user";

        Role superUserRole = new Role();
        superUserRole.setRoleName("SuperUser");
        User currentUser = new User();
        currentUser.setRole(superUserRole);
        when(userRepository.findByLogin(login)).thenReturn(Optional.of(currentUser));

        Role userRole = new Role();
        userRole.setRoleName("TEST");
        User user1 = new User();
        user1.setId(1L);
        user1.setName("HEHE");
        user1.setRole(userRole);

        User user2 = new User();
        user2.setId(2L);
        user2.setName("Admin");
        user2.setRole(superUserRole);

        List<User> userList = List.of(user1, user2);
        Page<User> usersPage = new PageImpl<>(userList, pageable, userList.size());
        when(userPageableRepository.findAllByOrderByEnabledDescIdAsc(pageable)).thenReturn(usersPage);

        doReturn(UserDto.builder().id(1L).name("HEHE").build()).when(userService).convertToUserDto(user1);
        doReturn(UserDto.builder().id(2L).name("Admin").build()).when(userService).convertToUserDto(user2);


        Page<UserDto> result = userService.getAllDtoUsers(pageable, login);

        assertNotNull(result);
        assertEquals(2, result.getTotalElements());
        assertEquals("HEHE", result.getContent().get(0).getName());
        assertEquals("Admin", result.getContent().get(1).getName());
    }


    @Test
    void testGetAllDtoUsers_FiltrationRegularUser() {
        Pageable pageable = PageRequest.of(0, 10);
        String login = "regular_user";

        Role userRole = new Role();
        userRole.setRoleName("Buhgalter");
        User currentUser = new User();
        currentUser.setRole(userRole);
        when(userRepository.findByLogin(login)).thenReturn(Optional.of(currentUser));

        Role superUserRole = new Role();
        superUserRole.setRoleName("SuperUser");

        User user1 = new User();
        user1.setId(1L);
        user1.setName("User1");
        user1.setRole(userRole);

        User user2 = new User();
        user2.setId(2L);
        user2.setName("SuperUser");
        user2.setRole(superUserRole);

        List<User> userList = List.of(user1, user2);
        Page<User> usersPage = new PageImpl<>(userList, pageable, userList.size());
        when(userPageableRepository.findAllByOrderByEnabledDescIdAsc(pageable)).thenReturn(usersPage);

        doReturn(UserDto.builder().id(1L).name("User1").build()).when(userService).convertToUserDto(user1);

        Page<UserDto> result = userService.getAllDtoUsers(pageable, login);

        assertNotNull(result);
        assertEquals(1, result.getTotalElements());
        assertEquals("User1", result.getContent().get(0).getName());
    }


    @Test
    void testGetAllDtoUsers_DisplayIndex() {
        Pageable pageable = PageRequest.of(0, 10);
        String login = "super_user";

        Role superUserRole = new Role();
        superUserRole.setRoleName("SuperUser");
        User currentUser = new User();
        currentUser.setRole(superUserRole);
        when(userRepository.findByLogin(login)).thenReturn(Optional.of(currentUser));

        User user1 = new User();
        user1.setId(1L);
        user1.setName("User1");

        User user2 = new User();
        user2.setId(2L);
        user2.setName("User2");

        List<User> userList = List.of(user1, user2);
        Page<User> usersPage = new PageImpl<>(userList, pageable, userList.size());
        when(userPageableRepository.findAllByOrderByEnabledDescIdAsc(pageable)).thenReturn(usersPage);

        doReturn(UserDto.builder().id(1L).name("User1").build()).when(userService).convertToUserDto(user1);
        doReturn(UserDto.builder().id(2L).name("User2").build()).when(userService).convertToUserDto(user2);

        Page<UserDto> result = userService.getAllDtoUsers(pageable, login);

        assertNotNull(result);
        assertEquals(1, result.getContent().get(0).getDisplayIndex());
        assertEquals(2, result.getContent().get(1).getDisplayIndex());
    }







    @Test
    void testEditUser_UserNotEnabled() {
        existingUser.setEnabled(false);
        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));

        UserDto userDto = new UserDto();
        userDto.setName("Updated");

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.editUser(1L, userDto));
        assertEquals("Удаленного пользователя нельзя редактировать", exception.getMessage());
    }


    @Test
    void testDeleteUser_Success() {
        when(userRepository.findById(12L)).thenReturn(Optional.of(existingUser));
        existingUser.setRole(new Role());
        existingUser.getRole().setId(1L);
        existingUser.getRole().setRoleName("Test");

        userService.deleteUser(12L);

        assertNull(existingUser.getRole());
        assertFalse(existingUser.isEnabled());
        verify(userRepository).save(existingUser);
    }

    @Test
    void testDeleteUser_CannotDeleteSuperUser() {
        existingUser.setRole(new Role());
        existingUser.getRole().setRoleName("SuperUser");
        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.deleteUser(1L));
        assertEquals("Нельзя удалить администратора системы", exception.getMessage());
    }


    @Test
    void testUpdateLoginAndPassword_Success() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));
        when(passwordEncoder.encode("Password123")).thenReturn("encoded_Password123");

        userService.updateLoginAndPassword(1L, "Naruto", "Password123");

        assertEquals("Naruto", existingUser.getLogin());
        assertEquals("encoded_Password123", existingUser.getPassword());
        verify(userRepository).save(existingUser);
    }

    @Test
    void testUpdateLoginAndPassword_ExistingLogin() {
        User anotherUser = new User();
        anotherUser.setId(2L);
        anotherUser.setLogin("anna_kozlova");

        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));
        when(userRepository.findByLogin("anna_kozlova")).thenReturn(Optional.of(anotherUser));

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.updateLoginAndPassword(1L, "anna_kozlova", "Password123"));
        assertEquals("Пользователь с таким логином уже существует", exception.getMessage());
    }

    @Test
    void testValidatePassword_ThrowsExceptionIfInvalid() {
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.updateLoginAndPassword(1L, "newLogin", "short"));
        assertEquals("Пароль должен содержать минимум 8 символов и максимум 20 на латыни", exception.getMessage());
    }


    @Test
    void testGetUserById_Success() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));

        User result = userService.getUserById(1L);

        assertNotNull(result);
        assertEquals(existingUser.getId(), result.getId());
        assertEquals(existingUser.getName(), result.getName());
        verify(userRepository).findById(1L);
    }


    @Test
    void testGetUserById_UserNotFound_ThrowsException() {
        when(userRepository.findById(1L)).thenReturn(Optional.empty());

        UsernameNotFoundException exception = assertThrows(
                UsernameNotFoundException.class,
                () -> userService.getUserById(1L)
        );

        assertEquals("User not found", exception.getMessage());
        verify(userRepository).findById(1L);
    }


    @Test
    void testGetUserDtoByLogin_Success() {
        String login = existingUser.getLogin();

        UserDto userDto = UserDto.builder()
                .id(existingUser.getId())
                .name(existingUser.getName())
                .login(existingUser.getLogin())
                .build();

        when(userRepository.findByLogin(login)).thenReturn(Optional.of(existingUser));
        doReturn(userDto).when(userService).convertToUserDto(existingUser);

        UserDto result = userService.getUserDtoByLogin(login);

        assertNotNull(result);
        assertEquals(existingUser.getId(), result.getId());
        assertEquals(existingUser.getName(), result.getName());
        verify(userRepository).findByLogin(login);
        verify(userService).convertToUserDto(existingUser);
    }


    @Test
    void testEditUser_Success() {
        Long userId = 1L;

        UserDto userDto = new UserDto();
        userDto.setName("Updated Name");
        userDto.setSurname("Updated Surname");
        userDto.setBirthday(LocalDate.of(1990, 5, 20));
        userDto.setEmail("updated@gmail.com");
        userDto.setNotes("Updated notes");
        userDto.setRoleDto(RoleDto.builder().id(2L).roleName("TEST").build());


        Role role = new Role();
        role.setId(2L);
        role.setRoleName("TEST");

        CompanyDto companyDto = CompanyDto.builder().id(1L).name("NEW COMPANY").build();
        userDto.setCompanies(List.of(companyDto));
        Company company = new Company();
        company.setId(1L);

        doReturn(existingUser).when(userService).getUserById(userId);
        doReturn(company).when(companyService).getCompanyById(1L);
        doReturn(role).when(roleService).getRoleById(2L);


        userService.editUser(userId, userDto);

        assertEquals("Updated Name", existingUser.getName());
        assertEquals("Updated Surname", existingUser.getSurname());
        assertEquals(LocalDate.of(1990, 5, 20), existingUser.getBirthday());
        assertEquals("updated@gmail.com", existingUser.getEmail());
        assertEquals("Updated notes", existingUser.getNotes());
        assertEquals(role, existingUser.getRole());
        verify(userCompanyService).updateUserCompanies(existingUser, List.of(company));
        verify(userRepository).save(existingUser);
    }





    @Test
    void testGetUserDtoByLogin_UserNotFound() {
        when(userRepository.findByLogin("dmitry_popovich")).thenReturn(Optional.empty());

        UsernameNotFoundException exception = assertThrows(UsernameNotFoundException.class, () -> userService.getUserDtoByLogin("dmitry_popovich"));
        assertEquals("user not found", exception.getMessage());
    }

    @Test
    void testCheckIfUserExists_UserExists() {
        when(userRepository.findByLogin("dmitry_popov")).thenReturn(Optional.of(existingUser));

        boolean result = userService.checkIfUserExists("dmitry_popov");

        assertTrue(result);
        verify(userRepository).findByLogin("dmitry_popov");
    }

    @Test
    void testCheckIfUserExists_UserNotFound() {
        when(userRepository.findByLogin("test_user")).thenReturn(Optional.empty());

        boolean result = userService.checkIfUserExists("test_user");

        assertFalse(result);
        verify(userRepository).findByLogin("test_user");
    }


    @Test
    void testGetUserDtoByCookie_UserNotFound() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        Cookie[] cookies = {new Cookie("username", "test_user")};
        when(request.getCookies()).thenReturn(cookies);
        when(userRepository.findByLogin("test_user")).thenReturn(Optional.empty());

        UserDto result = userService.getUserDtoByCookie(request);

        assertNull(result);
    }



    @Test
    void testGetUserForTaskDto_UserExists() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(existingUser));

        UserForTaskDto result = userService.getUserForTaskDto(1L);

        assertNotNull(result);
        assertEquals(existingUser.getLogin(), result.getLogin());
        verify(userRepository).findById(1L);
    }

    @Test
    void testGetUserForTaskDto_UserNotFound() {
        when(userRepository.findById(1L)).thenReturn(Optional.empty());

        UsernameNotFoundException exception = assertThrows(UsernameNotFoundException.class, () -> userService.getUserForTaskDto(1L));
        assertEquals("User not found for id: 1", exception.getMessage());
    }


}
