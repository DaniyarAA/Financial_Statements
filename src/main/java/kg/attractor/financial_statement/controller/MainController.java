package kg.attractor.financial_statement.controller;

import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.dto.PriorityDto;
import kg.attractor.financial_statement.dto.TaskDto;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.*;
import kg.attractor.financial_statement.utils.DateUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping()
public class MainController {
    private final UserService userService;
    private final TaskService taskService;
    private final PriorityService priorityService;
    private final CompanyService companyService;
    private final DocumentTypeService documentTypeService;
    private final TaskStatusService taskStatusService;

    @ModelAttribute
    public void addCommonAttributes(Model model) {
        model.addAttribute("showLogoutButton", true);
    }

    @GetMapping
    public String getMainPage(@RequestParam(required = false) Long companyId,
                              @RequestParam(required = false) Long userId,
                              Model model, HttpServletRequest request , Principal principal) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String login = auth.getName();
        User userDto = userService.getUserByLogin(login);

        if (userDto == null) {
            return "redirect:/login";
        }

        List<TaskDto> sortedTasks;
        if (companyId != null && userId != null) {
            sortedTasks = taskService.getTasksByUsers_IdAndCompany_Id(userId, companyId);
        } else if (companyId != null) {
            sortedTasks = taskService.getTasksByCompanyId(companyId);
        } else if (userId != null) {
            System.out.println("Зашел в 3 иф");
            sortedTasks = taskService.getTasksForUser(userId);
            System.out.println(sortedTasks);
        } else {
            sortedTasks = taskService.getAllTasks();
        }

        List<TaskDto> userTasks = taskService.getTasksForUser(userDto.getId());
        List<PriorityDto> priorities = priorityService.getAllPriorities();


        CsrfToken csrfToken = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
        model.addAttribute("csrfToken", csrfToken);
        boolean canOpenDocumentTools = false;
        boolean canOpenTaskTools = false;
        if (principal != null) {
            canOpenDocumentTools = userService.canOpenDocumentTools(principal.getName());
            canOpenTaskTools = userService.canOpenTaskTools(principal.getName());
        }
        boolean canCreateCompany = false;

        model.addAttribute("canOpenDocumentTools", canOpenDocumentTools);
        model.addAttribute("canOpenTaskTools", canOpenTaskTools);
        if (principal != null) {
            canCreateCompany = userService.canCreate(principal.getName());
        }
        model.addAttribute("userTasks", userTasks);
        model.addAttribute("csrfToken", csrfToken);
        model.addAttribute("canCreateCompany", canCreateCompany);
        model.addAttribute("companies", companyService.getAllCompanies());
        model.addAttribute("userDto", userDto);
        model.addAttribute("dateUtils", new DateUtils());
        model.addAttribute("userId", userId);
        model.addAttribute("companyId", companyId);
        model.addAttribute("priorities", priorities);
        model.addAttribute("defaultDocumentTypes",documentTypeService.getDefaultDocumentTypes());
        model.addAttribute("changeableDocumentTypes", documentTypeService.getChangeableDocumentTypes());
        model.addAttribute("defaultTaskStatuses",taskStatusService.getDefaultTaskStatuses());
        model.addAttribute("changeableTaskStatuses",taskStatusService.getChangeableTaskStatuses());
        model.addAttribute("currentUser", userService.getUserDtoByLogin(principal.getName()));

        model.addAttribute("userTasks", userTasks);
        model.addAttribute("users", userService.getAllAccountant());
        model.addAttribute("tasks", sortedTasks);
        return "main/mainPage";
    }



    @PostMapping("/calendar")
    public ResponseEntity<Map<LocalDate, Long>> getTaskCounts(@RequestBody Map<String, Integer> yearMonth, Principal principal) {
        return taskService.countOfTaskForDay(yearMonth,principal);
    }
}
