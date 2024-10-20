package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.UserDto;

import java.util.List;

public interface UserService {
    void registerUser(UserDto user);
    UserDto getUserById(Long id);
    UserDto getUserByLogin(String login);
    void updateUser(Long id, EditUserDto user);
    void deleteUser(Long id);
    List<UserDto> getAllUsers();

    boolean checkIfUserExists(String login);
}
