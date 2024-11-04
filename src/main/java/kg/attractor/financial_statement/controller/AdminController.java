package kg.attractor.financial_statement.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.*;
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
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating user: " + e.getMessage());
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
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Произошла ошибка на сервере");
        }
    }

    @DeleteMapping("roles/delete/{roleId}")
    @ResponseBody
    public ResponseEntity<Void> deleteRole(@PathVariable Long roleId) {
        roleService.deleteRole(roleId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/authorities")
    public ResponseEntity<List<AuthorityDto>> getAllAuthorities() {
        List<AuthorityDto> authorities = authorityService.getAll();
        return ResponseEntity.ok(authorities);
    }

}