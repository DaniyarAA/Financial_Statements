package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.*;
import kg.attractor.financial_statement.utils.DateUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("tasks")
public class TaskController {
    private final TaskService taskService;
    private final DocumentTypeService documentTypeService;
    private final UserService userService;
    private final TaskStatusService taskStatusService;
    private final CompanyService companyService;

    @GetMapping("test")
    public String getTasks(Model model) {
        List<TaskDto> tasks = taskService.getAllTasks();

        model.addAttribute("tasks", tasks);
        model.addAttribute("dateUtils", new DateUtils());
        return "tasks/tasksMain";
    }

    @GetMapping()
    public String getPageTasks(
            Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "9") int size,
            @RequestParam(value = "sort", defaultValue = "id") String sort,
            @RequestParam(value = "direction", defaultValue = "desc") String direction,
            @RequestParam(value = "documentType", required = false) Long documentTypeId,
            @RequestParam(value = "taskStatus", required = false) Long taskStatusId,
            Authentication authentication
    ) {
        List<DocumentTypeDto> documentTypeDtos = documentTypeService.getAllDocumentTypes();
        List<TaskStatusDto> taskStatusDtos = taskStatusService.getAllTaskStatuses();

        Page<TaskDto> tasksPage = taskService.getTasksPage(page, size, sort, direction, documentTypeId, taskStatusId);

        model.addAttribute("documentTypeDto", documentTypeDtos);
        model.addAttribute("taskStatusDtos", taskStatusDtos);
        model.addAttribute("taskDtos", tasksPage);

        model.addAttribute("documentTypeId", documentTypeId);
        model.addAttribute("taskStatusId", taskStatusId);

        model.addAttribute("direction", direction);
        model.addAttribute("sort", sort);
        model.addAttribute("page", page);
        model.addAttribute("size", size);

        model.addAttribute("dateUtils", new DateUtils());

        return "tasks/tasksPage";
    }

    @GetMapping("create")
    public String getCreateTaskForm(
            Model model,
            Authentication authentication
    ) {
        List<DocumentTypeDto> documentTypeDtos = documentTypeService.getAllDocumentTypes();
        List<UserDto> userDtos = userService.getAllUsers();
        List<CompanyDto> companyDtos = companyService.getAllCompanies();
        List<TaskStatusDto> taskStatusDtos = taskStatusService.getAllTaskStatuses();

        model.addAttribute("userDtos", userDtos);
        model.addAttribute("companyDtos", companyDtos);
        model.addAttribute("taskStatusDtos", taskStatusDtos);
        model.addAttribute("documentTypeDtos", documentTypeDtos);
        model.addAttribute("taskCreateDto", new TaskCreateDto());

        return "tasks/create";
    }

    @PostMapping("create")
    public String createTask(
            @Valid TaskCreateDto taskCreateDto,
            BindingResult bindingResult,
            Model model,
            Authentication authentication
    ) {
        if (bindingResult.hasErrors() ) {
            List<DocumentTypeDto> documentTypeDtos = documentTypeService.getAllDocumentTypes();
            model.addAttribute("documentTypeDtos", documentTypeDtos);
            model.addAttribute("taskCreateDto", taskCreateDto);

            return "tasks/create";
        }
        Long id = taskService.createTask(taskCreateDto, authentication.getName());
        return "redirect:/tasks";

    }

    @GetMapping("dashboard")
    public String getDashboardPage(
            Model model,
            Authentication authentication
    ) {

        if (authentication == null) {
            return "redirect:/login";
        }
        String userLogin = authentication.getName();
        User user = userService.getUserByLogin(userLogin);

        List<CompanyForTaskDto> companyDtos = companyService.getAllCompaniesForUser(user);
        List<TaskDto> taskDtos = taskService.getAllTasksForUser(user);

        Set<YearMonth> uniqueYearMonths = taskDtos.stream()
                .map(task -> YearMonth.from(task.getStartDateTime()))
                .collect(Collectors.toSet());

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");

        Map<YearMonth, Map<Long, List<TaskDto>>> tasksByYearMonthAndCompany = new LinkedHashMap<>();

        for (YearMonth yearMonth : uniqueYearMonths) {
            Map<Long, List<TaskDto>> tasksForCompanies = new HashMap<>();
            for (CompanyForTaskDto company : companyDtos) {
                List<TaskDto> tasksForCompanyAndMonth = taskDtos.stream()
                        .filter(task -> YearMonth.from(task.getStartDateTime()).equals(yearMonth) && task.getCompany().getId().equals(company.getId()))
                        .collect(Collectors.toList());
                tasksForCompanies.put(company.getId(), tasksForCompanyAndMonth);
            }
            tasksByYearMonthAndCompany.put(yearMonth, tasksForCompanies);
        }

        Map<String, String> monthsMap = uniqueYearMonths.stream()
                .collect(Collectors.toMap(
                        ym -> ym.format(formatter),
                        ym -> ym.getMonth().getDisplayName(TextStyle.FULL, new Locale("ru")) + " " + ym.getYear(),
                        (oldValue, newValue) -> oldValue,
                        LinkedHashMap::new
                ));


        model.addAttribute("monthsMap", monthsMap);
        model.addAttribute("companyDtos", companyDtos);
        model.addAttribute("tasksByYearMonthAndCompany", tasksByYearMonthAndCompany);

        return "tasks/dashboard";
    }
}
