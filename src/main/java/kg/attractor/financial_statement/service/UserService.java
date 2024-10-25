package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.entity.User;

import java.util.List;

public interface UserService {
    void registerUser(UserDto user);
    UserDto getUserDtoById(Long id);

    User getUserById(Long id);

    UserDto getUserDtoByLogin(String login);
    void updateUser(Long id, EditUserDto user);
    void deleteUser(Long id);
    List<UserDto> getAllDtoUsers();

    boolean checkIfUserExists(String login);
}
