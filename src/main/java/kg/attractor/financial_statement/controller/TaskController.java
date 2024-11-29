package kg.attractor.financial_statement.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.*;
import kg.attractor.financial_statement.utils.DateUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("tasks")
public class TaskController {
    private final TaskService taskService;
    private final DocumentTypeService documentTypeService;
    private final UserService userService;
    private final TaskStatusService taskStatusService;
    private final CompanyService companyService;
    private final TagService tagService;

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
        List<DocumentTypeDto> documentTypeDtos = documentTypeService.getFilteredDocumentTypes();
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

    @GetMapping("edit/{id}")
    public String getEditTaskForm(
            @PathVariable Long id,
            Model model
    ) {
        TaskDto taskDto = taskService.getTaskById(id);
        List<DocumentTypeDto> documentTypeDtos = documentTypeService.getAllDocumentTypes();
        List<TaskStatusDto> taskStatusDtos = taskStatusService.getAllTaskStatuses();
        List<CompanyDto> companyDtos = companyService.getAllCompanies();

        model.addAttribute("taskDto", taskDto);
        model.addAttribute("documentTypeDtos", documentTypeDtos);
        model.addAttribute("taskStatusDtos", taskStatusDtos);
        model.addAttribute("companyDtos", companyDtos);
        model.addAttribute("taskEditDto", new TaskEditDto());
        model.addAttribute("dateUtils", new DateUtils());

        return "tasks/edit";
    }

    @PostMapping("delete/{id}")
    public String deleteTask(@PathVariable Long id) {
        taskService.deleteTask(id);
        return "redirect:/tasks";
    }

    @GetMapping("list")
    public String getTaskListPage(
            Model model,
            Authentication authentication,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "8") int size,
            @RequestParam(required = false, defaultValue = "") String yearMonth
    ) throws JsonProcessingException {
        if (authentication == null) {
            return "redirect:/login";
        }

        String userLogin = authentication.getName();
        User user = userService.getUserByLogin(userLogin);

        Map<String, Object> taskListData = taskService.getTaskListData(user, page, size, yearMonth);
        System.out.println("taskListData: " + taskListData);

        List<TaskStatusDto> taskStatusDtos = taskStatusService.getAllTaskStatuses();
        ObjectMapper objectMapper = new ObjectMapper();
        String taskStatusDtosJson = objectMapper.writeValueAsString(taskStatusDtos);
        System.out.println("Json: " + taskStatusDtosJson);

        model.addAllAttributes(taskListData);
        model.addAttribute("taskStatusDtosJson", taskStatusDtosJson);
        model.addAttribute("dateUtils", new DateUtils());

        return "tasks/tasksList";
    }

    @PostMapping("/edit")
    @ResponseBody
    public ResponseEntity<Map<String, String>> updateTaskByField(@RequestBody Map<String, String> data) {
        return taskService.editTaskByField(data);
    }

    @PostMapping("/edit/{id}")
    public String updateTaskInListPage(
            @Valid @ModelAttribute("taskDto") TaskForTaskListEditDto taskDto,
            @PathVariable Long id,
            BindingResult bindingResult,
            Model model,
            Authentication authentication
    ) {
        if (bindingResult.hasErrors() ) {
            model.addAttribute("taskDto", taskDto);
            return "tasks/tasksList";
        }
        if (!taskService.checkIsAuthor(authentication.getName(), id)) {
            return "redirect:/login";
        }
        taskService.editTaskFromTasksList(taskDto, authentication.getName(), id);
        return "redirect:/tasks/list";

    }

    @PostMapping("/{taskId}/priority")
    public ResponseEntity<String> updateTaskPriority(@PathVariable Long taskId, @RequestParam Long priorityId) {
        System.out.println("Task ID: " + taskId + ", Priority ID: " + priorityId);
        taskService.updateTaskPriority(taskId, priorityId);
        return ResponseEntity.ok("Priority updated successfully");
    }

    @PostMapping("/tag")
    public ResponseEntity<Void> createTag(@RequestBody TagDto tagDto, Authentication authentication) {
        String login = authentication.getName();
        User user = userService.getUserByLogin(login);

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        tagDto.setUserId(user.getId());
        tagService.createTag(tagDto);

        return ResponseEntity.ok().build();
    }
}
