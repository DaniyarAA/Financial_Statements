package kg.attractor.financial_statement.service;

import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.dto.UserDetailsDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.dto.UserForTaskDto;
import kg.attractor.financial_statement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;


public interface UserService {
    Boolean messageIsSuccessfullySent(Map<String, Object> answer);

    Map<String, Object> sendMessageToUser(HttpServletRequest request);

    Long registerUser(UserDto user);

    UserDto getUserDtoById(Long id);

    UserDetailsDto getUserDetailDto(Long userId);

    User getUserById(Long id);

    UserDto getUserDtoByLogin(String login);

    void editUser(Long id, UserDto userDto) throws MessagingException, UnsupportedEncodingException;

    void updateLoginAndPassword(Long userId, String newLogin, String newPassword);

    String updateAvatar(Long userId, MultipartFile file) throws IOException;

    void deleteUser(Long id);

    Page<UserDto> getAllDtoUsers(Pageable pageable, String login);

    boolean checkIfUserExistsByLogin(String login);

    boolean checkIfUserExistsByEmail(String email);

    UserDto getUserDtoByCookie(HttpServletRequest request);

    List<UserDto> getAllUsers();

    UserForTaskDto getUserForTaskDto(Long id);

    UserForTaskDto getUserForTaskDto(User user);

    User getUserByLogin(String login);

    UserDto convertToUserDto(User user);

    Boolean isAdmin(String name);

    List<UserDto> getDeletedUsers();

    void resumeUser(Long id, Long roleId);

    boolean canEdit(String name);

    boolean canCreate(String name);

    boolean canReturn(String name);

    boolean canViewCompany(String name);
}
