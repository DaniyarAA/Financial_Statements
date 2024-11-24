package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.RoleService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserServiceImplTest {

    @Mock
    private UserRepository userRepository;


    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private RoleService roleService;

    @InjectMocks
    private UserServiceImpl userService;

    private User existingUser;

    @BeforeEach
    void setUp() {
        existingUser = new User();
        existingUser.setId(1L);
        existingUser.setName("Test");
        existingUser.setSurname("User");
        existingUser.setLogin("test_user");
        existingUser.setPassword("password");
        existingUser.setEnabled(true);
        existingUser.setBirthday(LocalDate.of(1990, 1, 1));
        existingUser.setRegisterDate(LocalDate.now());
        existingUser.setAvatar("user.png");
    }

    @Test
    void testRegisterUser_Success() {
        UserDto userDto = new UserDto();
        userDto.setName("Test");
        userDto.setSurname("User");
        userDto.setLogin("test_user");
        userDto.setPassword("password");
        userDto.setBirthday(LocalDate.of(1990, 1, 1));
        RoleDto roleDto = new RoleDto();
        roleDto.setId(1L);
        userDto.setRoleDto(roleDto);

        Role role = new Role();
        role.setId(1L);

        when(roleService.getRoleById(1L)).thenReturn(role);
        when(passwordEncoder.encode(userDto.getPassword())).thenReturn("encoded_password");

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
    void testGetUserDtoById_UserNotFound() {
        when(userRepository.findById(1L)).thenReturn(Optional.empty());

        UsernameNotFoundException exception = assertThrows(UsernameNotFoundException.class, () -> userService.getUserDtoById(1L));
        assertEquals("User not found", exception.getMessage());
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
