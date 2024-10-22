package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.dto.UserForTaskDto;

import java.util.List;

public interface UserService {
    boolean checkIfUserExists(String login);

    UserForTaskDto getUserForTaskDto(Long id);

    void registerUser(UserDto userDto);

    void deleteUser(Long id);

    List<UserDto> getAllUsers();

    UserDto getUserById(Long id);

    UserDto getUserByLogin(String login);

    void updateUser(Long id, EditUserDto userDto);
}
