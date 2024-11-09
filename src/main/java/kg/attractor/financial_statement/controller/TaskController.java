package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.*;
import kg.attractor.financial_statement.utils.DateUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("list")
    public String getTaskListPage(
            Model model,
            Authentication authentication,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "7") int size
    ) {
        if (authentication == null) {
            return "redirect:/login";
        }

        String userLogin = authentication.getName();
        User user = userService.getUserByLogin(userLogin);

        List<CompanyForTaskDto> companyDtos = companyService.getAllCompaniesForUser(user);
        System.out.println("CompanyDtos" +companyDtos);
        List<TaskDto> taskDtos = taskService.getAllTasksForUser(user);

        Set<String> uniqueYearMonths = taskDtos.stream()
                .map(task -> YearMonth.from(task.getStartDateTime()).format(DateTimeFormatter.ofPattern("MM.yyyy")))
                .collect(Collectors.toSet());

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");

        Map<String, Map<String, List<TaskDto>>> tasksByYearMonthAndCompany = new LinkedHashMap<>();

        for (String yearMonth : uniqueYearMonths) {
            Map<String, List<TaskDto>> tasksForCompanies = new HashMap<>();
            for (CompanyForTaskDto company : companyDtos) {
                List<TaskDto> tasksForCompanyAndMonth = taskDtos.stream()
                        .filter(task -> YearMonth.from(task.getStartDateTime()).format(formatter).equals(yearMonth)
                                && task.getCompany().getId().equals(company.getId()))
                        .collect(Collectors.toList());
                tasksForCompanies.put(company.getId().toString(), tasksForCompanyAndMonth);
            }
            tasksByYearMonthAndCompany.put(yearMonth, tasksForCompanies);
        }

        Map<String, String> monthsMap = uniqueYearMonths.stream()
                .collect(Collectors.toMap(
                        ym -> ym,
                        ym -> YearMonth.parse(ym, formatter)
                                .getMonth()
                                .getDisplayName(TextStyle.FULL, new Locale("ru")) + " " + YearMonth.parse(ym, formatter).getYear(),
                        (oldValue, newValue) -> oldValue,
                        LinkedHashMap::new
                ));

        int totalCompanies = companyDtos.size();
        int start = page * size;
        int end = Math.min(start + size, totalCompanies);

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCompanies / size));
        model.addAttribute("list", companyDtos.subList(start, end));

        model.addAttribute("monthsMap", monthsMap);
        model.addAttribute("companyDtos", companyDtos);
        model.addAttribute("tasksByYearMonthAndCompany", tasksByYearMonthAndCompany);

        model.addAttribute("dateUtils", new DateUtils());

        return "tasks/tasksList";
    }

    @PostMapping("/edit")
    @ResponseBody
    public ResponseEntity<Map<String, String>> updateTaskByField(@RequestBody Map<String, String> data) {
        return taskService.editTaskByField(data);
    }

//    @PostMapping("/edit/{id}")
//    public String updateTaskInListPage(
//            @Valid @ModelAttribute("taskDto") TaskDto taskDto,
//            @PathVariable Long id,
//            BindingResult bindingResult,
//            Model model,
//            Authentication authentication
//            ) {
//
//
//    }
}
