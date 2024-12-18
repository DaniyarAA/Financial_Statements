package kg.attractor.financial_statement.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.error.WrongRoleNameException;
import kg.attractor.financial_statement.service.AuthorityService;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("admin")
@RequiredArgsConstructor

public class AdminController {

    private final UserService userService;
    private final RoleService roleService;
    private final AuthorityService authorityService;

    @GetMapping("register")
    public String register(Model model) {
        model.addAttribute("userDto", new UserDto());
        model.addAttribute("roles", roleService.getAll());
        return "admin/register";
    }

    @PostMapping("register")
    public String register(@Valid UserDto userDto, BindingResult bindingResult, Model model, HttpSession session) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("roles", roleService.getAll());
            return "admin/register";
        }
        try {
            Long userId = userService.registerUser(userDto);
            session.setAttribute("userId", userId);
            model.addAttribute("userDto", userDto);
            return "admin/message";
        } catch (IllegalArgumentException e) {
            model.addAttribute("roles", roleService.getAll());
            model.addAttribute("error", e.getMessage());
            return "admin/register";
        }

    }

    @PostMapping("/message")
    public String messageToNewUserPost(HttpServletRequest request, Model model, HttpSession session) {
        Map<String, Object> answer = userService.sendMessageToUser(request);
        if (userService.messageIsSuccessfullySent(answer)){
            return "redirect:/admin/users?userId=" + session.getAttribute("userId");
        }
        model.addAttribute(answer);
        return "admin/message";
    }

    @GetMapping("users")
    public String getAllUsers(Model model, @PageableDefault(size = 8) Pageable pageable, Principal principal) {
        var users = userService.getAllDtoUsers(pageable, principal.getName());
        model.addAttribute("currentUser", userService.getUserDtoByLogin(principal.getName()));
        model.addAttribute("users", users);
        return "admin/users";
    }

    @GetMapping("users/edit/{id}")
    @ResponseBody
    public UserDetailsDto getUserById(@PathVariable Long id) {
        return userService.getUserDetailDto(id);
    }

    @PostMapping("users/edit/{id}")
    @ResponseBody
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody UserDto userDto) {
        try {
            userService.editUser(id, userDto);
            return ResponseEntity.ok("User updated successfully");
        } catch (IllegalArgumentException e) {
            String errorMessage = e.getMessage();
            return switch (errorMessage) {
                case "Удаленного пользователя нельзя редактировать!" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "USER_DISABLED"));
                case "Заполните дату рождения!" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "BIRTHDAY_MISSING"));
                case "Заполните имя и фамилию!" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "NAME_SURNAME_MISSING"));
                case "Дата рождения указана неверно: сотрудник еще не родился" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "INVALID_BIRTHDAY"));
                case "Возраст сотрудника должен быть не менее 18 лет для трудоустройства" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "AGE_TOO_YOUNG"));
                case "Возраст сотрудника не должен превышать 100 лет" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "AGE_TOO_OLD"));
                case "Пользователь с такой почтой уже существует" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "EMAIL_ALREADY_EXISTS"));
                case "Заполните почту!" ->
                        ResponseEntity.badRequest().body(Map.of("message", errorMessage, "errorCode", "EMAIL_MISSING"));
                case null, default ->
                        ResponseEntity.badRequest().body(Map.of("message", "Неизвестная ошибка валидации", "errorCode", "UNKNOWN_VALIDATION_ERROR"));
            };
        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @DeleteMapping("/user/delete/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    @GetMapping("/login-check")
    public ResponseEntity<Boolean> checkFirstLogin(Principal principal) {
        User user = userService.getUserByLogin(principal.getName());
        return ResponseEntity.ok(user.isCredentialsNonExpired());
    }

    @GetMapping("roles")
    public String getAllRoles(Model model, Principal principal) {
        List<RoleDto> roles = roleService.getAll();
        model.addAttribute("roles", roles);
        model.addAttribute("authorities", authorityService.getAll());
        model.addAttribute("createRoleDto", new CreateRoleDto());
        model.addAttribute("currentUser", userService.getUserDtoByLogin(principal.getName()));
        return "admin/roles";
    }

    @GetMapping("roles/checkRoleName")
    @ResponseBody
    public boolean checkRoleName(@RequestParam String name) {
        return roleService.checkIfRoleNameExists(name);
    }

    @PostMapping("roles/create")
    @ResponseBody
    public ResponseEntity<Void> createRole(@RequestBody CreateRoleDto createRoleDto) {
        roleService.createNewRole(createRoleDto);
        if (createRoleDto.getRoleName() == null || createRoleDto.getRoleName().trim().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("roles/edit/{roleId}")
    @ResponseBody
    public RoleDto getRole(@PathVariable Long roleId) {
        return roleService.getRoleDtoById(roleId);
    }

    @PostMapping("roles/edit/{id}")
    @ResponseBody
    public ResponseEntity<?> updateRole(@PathVariable Long id, @RequestBody RoleDto roleDto) {
        try {
            roleService.updateRole(id, roleDto);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            if (e.getMessage().contains("существует")) {
                return ResponseEntity.badRequest().body(Map.of("error", "duplicate", "message", e.getMessage()));
            }
            return ResponseEntity.badRequest().body(Map.of("error", "validation", "message", e.getMessage()));
        } catch (WrongRoleNameException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "validation", "message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Произошла ошибка на сервере");
        }
    }

    @DeleteMapping("roles/delete/{roleId}")
    @ResponseBody
    public ResponseEntity<?> deleteRole(@PathVariable Long roleId) {
        try {
            roleService.deleteRole(roleId);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "validation", "message", e.getMessage()));
        }
    }

    @GetMapping("/authorities")
    public ResponseEntity<List<AuthorityDto>> getAllAuthorities() {
        List<AuthorityDto> authorities = authorityService.getAll();
        return ResponseEntity.ok(authorities);
    }

    @PostMapping("users/change-login-password/{userId}")
    public ResponseEntity<?> changeUserLoginAndPassword(@PathVariable Long userId, @RequestBody Map<String, String> loginAndPassword) {
        try {
            String newLogin = loginAndPassword.get("newLogin");
            String newPassword = loginAndPassword.get("newPassword");
            userService.updateLoginAndPassword(userId, newLogin, newPassword);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

}