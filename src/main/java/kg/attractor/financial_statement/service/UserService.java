package kg.attractor.financial_statement.service;

import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.io.IOException;


public interface UserService {
    void registerUser(UserDto user);
    UserDto getUserDtoById(Long id);

    User getUserById(Long id);

    UserDto getUserDtoByLogin(String login);
    void updateUser(Long id, EditUserDto user) throws IOException;
    void deleteUser(Long id);
    //List<UserDto> getAllDtoUsers();

    Page<UserDto> getAllDtoUsers(Pageable pageable);

    boolean checkIfUserExists(String login);

    UserDto getUserDtoByCookie(HttpServletRequest request);
}
