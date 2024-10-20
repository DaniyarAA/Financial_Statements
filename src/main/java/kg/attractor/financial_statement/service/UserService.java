package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.UserDto;

import java.util.List;

public interface UserService {
    void registerUser(UserDto user);
    UserDto getUserById(Long id);
    UserDto getUserByLogin(String login);
    void updateUser(UserDto user);
    void deleteUser(Long id);
    List<UserDto> getAllUsers();
}
