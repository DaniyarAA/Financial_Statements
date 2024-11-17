package kg.attractor.financial_statement.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.UserDetailsDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.dto.UserForTaskDto;
import kg.attractor.financial_statement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;


public interface UserService {
    void registerUser(UserDto user);
    UserDto getUserDtoById(Long id);

    UserDetailsDto getUserDetailDto(Long userId);

    User getUserById(Long id);

    UserDto getUserDtoByLogin(String login);

    void editUser(Long id, UserDto userDto);

    void updateLoginAndPassword(Long userId, String newLogin, String newPassword);

    String updateAvatar(Long userId, MultipartFile file) throws IOException;

    void deleteUser(Long id);
    //List<UserDto> getAllDtoUsers();

    Page<UserDto> getAllDtoUsers(Pageable pageable);

    boolean checkIfUserExists(String login);

    UserDto getUserDtoByCookie(HttpServletRequest request);

    List<UserDto> getAllUsers();

    UserForTaskDto getUserForTaskDto(Long id);

    User getUserByLogin(String login);

    UserDto convertToUserDto(User user);

    Boolean isAdmin(String name);
}
