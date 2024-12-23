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

    @PostMapping("delete/{id}")
    public String deleteTask(@PathVariable Long id) {
        taskService.deleteTask(id);
        return "redirect:/tasks";
    }

    @GetMapping()
    public String getTaskListPage(
            Model model,
            Authentication authentication,
            @RequestParam(value = "openModal", required = false, defaultValue = "false") boolean openModal
    ) throws JsonProcessingException {
        if (authentication == null) {
            return "redirect:/login";
        }

        String userLogin = authentication.getName();
        User user = userService.getUserByLogin(userLogin);

        Map<String, Object> taskListData = taskService.getTaskListData(user);
        List<CompanyForTaskDto> companiesList = (List<CompanyForTaskDto>) taskListData.get("companyDtos");
        if (companiesList == null || companiesList.isEmpty()) {
            model.addAttribute("errorMsg", "У вас нет компаний");
        }

        List<TaskStatusDto> taskStatusDtos = taskStatusService.getAllTaskStatuses();
        ObjectMapper objectMapper = new ObjectMapper();
        String taskStatusDtosJson = objectMapper.writeValueAsString(taskStatusDtos);

        List<DocumentTypeDto> documentTypeDtos = documentTypeService.getFilteredDocumentTypes();
        List<UserDto> userDtos = userService.getAllUsers();
        List<CompanyDto> companyDtos = companyService.getAllCompanies();

        String companyDtosJson = objectMapper.writeValueAsString(companyDtos);

        model.addAllAttributes(taskListData);

        model.addAttribute("taskStatusDtosJson", taskStatusDtosJson);
        model.addAttribute("dateUtils", new DateUtils());
        model.addAttribute("userDtos", userDtos);
        model.addAttribute("companies", companyDtos);
        model.addAttribute("companyDtosJson", companyDtosJson);
        model.addAttribute("taskStatusDtos", taskStatusDtos);
        model.addAttribute("documentTypeDtos", documentTypeDtos);
        model.addAttribute("taskCreateDto", new TaskCreateDto());
        model.addAttribute("openModal", openModal);

        System.out.println("taskListData: " + taskListData);

        System.out.println("Json task statuses: " + taskStatusDtosJson);

        return "tasks/tasksList";
    }

    @PostMapping("create")
    @ResponseBody
    public ResponseEntity<?> createTaskInListPage(
            @Valid TaskCreateDto taskCreateDto,
            Model model,
            Authentication authentication
    ) {
        if (!taskService.createIsValid(taskCreateDto)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Выбраны неправильные даты!"));
        }
        Long id = taskService.createTask(taskCreateDto, authentication.getName());
        return ResponseEntity.ok(Map.of("success", "Успешно обновлено!"));
    }

    @PostMapping("/edit/{id}")
    @ResponseBody
    public ResponseEntity<?> updateTaskInListPage(
            @Valid @ModelAttribute("taskDto") TaskForTaskListEditDto taskDto,
            @PathVariable Long id,
            Authentication authentication
    ) {
        if (!taskService.checkIsAuthor(authentication.getName(), id)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Вы не имеете прав редактировать эту задачу!"));
        }

        if (!taskService.areValidDates(taskDto.getFrom(), taskDto.getTo())) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Выбраны неправильные даты!"));
        }

        taskService.editTaskFromTasksList(taskDto, authentication.getName(), id);
        return ResponseEntity.ok(Map.of("success", "Успешно обновлено!"));
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

    @GetMapping("/tags/user")
    @ResponseBody
    public List<TagDto> getUserTags(Authentication authentication) {
        String login = authentication.getName();
        User userDto = userService.getUserByLogin(login);

        if (userDto == null) {
            throw new NoSuchElementException("User not found");
        }

        return tagService.getTagsByUserId(userDto.getId());
    }

    @GetMapping("/{taskId}/tag")
    public ResponseEntity<TagDto> getTaskTag(@PathVariable Long taskId) {
        TagDto tag = tagService.getTagForTask(taskId);
        if (tag == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(tag);
    }

    @PostMapping("/tag/update")
    public ResponseEntity<Void> updateTag(@RequestBody TagUpdateDto tagUpdateDto, Authentication authentication) {
        String login = authentication.getName();
        User user = userService.getUserByLogin(login);

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        tagService.updateTagForTask(tagUpdateDto.getTaskId(), tagUpdateDto.getTagId());

        return ResponseEntity.ok().build();
    }
}