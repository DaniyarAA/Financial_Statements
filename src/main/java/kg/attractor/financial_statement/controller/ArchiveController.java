package kg.attractor.financial_statement.controller;

import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequestMapping("archive")
@RequiredArgsConstructor
public class ArchiveController {

    private final UserService userService;
    private final TaskService taskService;
    private final CompanyService companyService;
    private final RoleService roleService;
    private final TaskStatusService taskStatusService;

    @GetMapping("/all")
    public String getFullArchive(Model model) {
        model.addAttribute("deletedUsers", userService.getDeletedUsers());
        model.addAttribute("finishedTasks", taskService.getAllFinishedTasks());
        model.addAttribute("deletedCompanies", companyService.getAllDeletedCompanies());
        model.addAttribute("roles", roleService.getAll());
        model.addAttribute("statuses", taskStatusService.getAllTaskStatuses());
        return "archive/all";
    }

    @GetMapping
    public String getUserArchive(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.getUserByLogin(authentication.getName());
        model.addAttribute("currentUser", user);
        model.addAttribute("userFinishedTasks", taskService.getFinishedTasksForUser());
        model.addAttribute("deletedCompaniesByUser", companyService.getDeletedCompaniesByUser(user.getId()));
        return "archive/forUser";
    }

    @PostMapping("/resume/user/{id}")
    public ResponseEntity<?> resumeUser(@PathVariable Long id, @RequestBody Map<String, Long> body) {
        Long roleId = body.get("roleId");
        if (roleId == null) {
            return ResponseEntity.badRequest().body("Role ID is required");
        }

        userService.resumeUser(id, roleId);
        return ResponseEntity.ok("User restored successfully");
    }

    @PostMapping("/resume/company/{id}")
    public ResponseEntity<Void> resumeCompany(@PathVariable Long id) {
        companyService.resumeCompany(id);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/change_status/{id}")
    public ResponseEntity<?> resumeTask(@PathVariable Long id, @RequestBody Map<String, Long> body) {
        Long statusId = body.get("statusId");
        if (statusId == null) {
            return ResponseEntity.badRequest().body("Task ID is required");
        }

        taskService.updateTaskStatus(id, statusId);
        return ResponseEntity.ok("Task status updated successfully");
    }

}