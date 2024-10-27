package kg.attractor.financial_statement.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.CreateRoleDto;
import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("admin")
@RequiredArgsConstructor

public class AdminController {

    private final UserService userService;
    private final RoleService roleService;

    @GetMapping("register")
    public String register(Model model) {
        model.addAttribute("userDto", new UserDto());
        model.addAttribute("roles", roleService.getAll());
        return "admin/register";
    }

    @PostMapping("register")
    public String register(@Valid UserDto userDto, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("roles", roleService.getAll());
            return "admin/register";
        }
        try {
            userService.registerUser(userDto);
            return "redirect:/admin/users";
        } catch (IllegalArgumentException e) {
            model.addAttribute("roles", roleService.getAll());
            model.addAttribute("error", e.getMessage());
            return "admin/register";
        }

    }

    @GetMapping("users")
    public String getAllUsers(Model model, @PageableDefault(size = 6, sort = "id", direction = Sort.Direction.ASC) Pageable pageable) {
       var users = userService.getAllDtoUsers(pageable);
        model.addAttribute("users", users);
        return "admin/users";
    }

    @GetMapping("user/edit/{id}")
    public String editUser(@PathVariable("id") Long id, Model model) {
        List<RoleDto> roles = roleService.getAll();
        model.addAttribute("editUserDto", userService.getUserDtoById(id));
        model.addAttribute("roles", roles);
        return "admin/edit_user";
    }

    @PostMapping("user/edit/{id}")
    public String editUser(@PathVariable("id") Long id, @Valid EditUserDto userDto, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("editUserDto", userService.getUserDtoById(id));
            model.addAttribute("roles", roleService.getAll());
            return "admin/edit_user";
        }

        try {
            userService.updateUser(id, userDto);
            return "redirect:/admin/users";
        } catch (IOException | IllegalArgumentException e){
            model.addAttribute("error", e.getMessage());
            model.addAttribute("editUserDto", userService.getUserDtoById(id));
            model.addAttribute("roles", roleService.getAll());
            return "admin/edit_user";
        }

    }

    @GetMapping("create/role")
    public String createRole(Model model) {
        model.addAttribute("createRoleDto", new CreateRoleDto());
        return "admin/create_role";
    }

    @PostMapping("create/role")
    public String createRole(@Valid CreateRoleDto roleDto, BindingResult bindingResult, Model model,
                             HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("createRoleDto", roleDto);
            return "admin/create_role";
        }
        roleService.createNewRole(roleDto);
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/admin/users");
    }

    @DeleteMapping("/user/delete/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok().build();
    }

}