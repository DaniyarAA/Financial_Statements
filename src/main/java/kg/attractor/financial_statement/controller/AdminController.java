package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.service.RoleService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
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

        userService.registerUser(userDto);
        return "redirect:/";
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
        model.addAttribute("editUserDto",  userService.getUserDtoById(id));
        if (bindingResult.hasErrors()) {
            return "admin/edit_user";
        }
        userService.updateUser(id, userDto);
        return "redirect:/admin/users";
    }
}