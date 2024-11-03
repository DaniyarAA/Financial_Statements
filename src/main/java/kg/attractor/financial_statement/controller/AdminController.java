package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.CreateRoleDto;
import kg.attractor.financial_statement.dto.EditUserDto;
import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.service.AuthorityService;
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
    private final AuthorityService authorityService;

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
        } catch (IOException e){
            model.addAttribute("error", e.getMessage());
            model.addAttribute("editUserDto", userService.getUserDtoById(id));
            model.addAttribute("roles", roleService.getAll());
            return "admin/edit_user";
        }

    }

    @DeleteMapping("/user/delete/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("roles")
    public String getAllRoles(Model model) {
        List<RoleDto> roles = roleService.getAll();
        model.addAttribute("roles", roles);
        model.addAttribute("authorities", authorityService.getAll());
        model.addAttribute("createRoleDto", new CreateRoleDto());
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
        return roleService.convertToDto(roleService.getRoleById(roleId));
    }

    @PostMapping("/admin/roles/edit/{id}")
    public ResponseEntity<?> updateRole(
            @PathVariable Long id,
            @RequestBody RoleDto roleDto) {

        roleService.updateRole(id, roleDto);

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("roles/delete/{roleId}")
    @ResponseBody
    public ResponseEntity<Void> deleteRole(@PathVariable Long roleId) {
        roleService.deleteRole(roleId);
        return ResponseEntity.ok().build();
    }

}