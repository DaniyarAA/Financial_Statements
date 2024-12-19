//package kg.attractor.financial_statement.controller;
//
//import com.fasterxml.jackson.core.JsonProcessingException;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import jakarta.validation.Valid;
//import kg.attractor.financial_statement.dto.*;
//import kg.attractor.financial_statement.entity.User;
//import kg.attractor.financial_statement.service.*;
//import kg.attractor.financial_statement.utils.DateUtils;
//import lombok.RequiredArgsConstructor;
//import org.springframework.data.domain.Page;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.Authentication;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.validation.BindingResult;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.*;
//
//@Controller
//@RequiredArgsConstructor
//@RequestMapping("tasks")
//public class TaskController {
//    private final TaskService taskService;
//    private final DocumentTypeService documentTypeService;
//    private final UserService userService;
//    private final TaskStatusService taskStatusService;
//    private final CompanyService companyService;
//    private final TagService tagService;
//
//    @PostMapping("create")
//    public String createTask(
//            @Valid TaskCreateDto taskCreateDto,
//            BindingResult bindingResult,
//            Model model,
//            Authentication authentication
//    ) {
//        if (bindingResult.hasErrors() ) {
//            List<DocumentTypeDto> documentTypeDtos = documentTypeService.getAllDocumentTypes();
//            model.addAttribute("documentTypeDtos", documentTypeDtos);
//            model.addAttribute("taskCreateDto", taskCreateDto);
//
//            return "tasks/create";
//        }
//        if (taskCreateDto.getEndDate() == null || taskCreateDto.getStartDate() == null) {
//            return "redirect:/tasks";
//        }
//
//        Long id = taskService.createTask(taskCreateDto, authentication.getName());
//        return "redirect:/tasks";
//
//    }
//
//
//    @PostMapping("delete/{id}")
//    public String deleteTask(@PathVariable Long id) {
//        taskService.deleteTask(id);
//        return "redirect:/tasks";
//    }
//
//    @GetMapping()
//    public String getTaskListPage(
//            Model model,
//            Authentication authentication,
//            @RequestParam(required = false, defaultValue = "0") int page,
//            @RequestParam(required = false, defaultValue = "8") int size,
//            @RequestParam(required = false, defaultValue = "") String yearMonth,
//            @RequestParam(value = "openModal", required = false, defaultValue = "false") boolean openModal
//            ) throws JsonProcessingException {
//        if (authentication == null) {
//            return "redirect:/login";
//        }
//
//        String userLogin = authentication.getName();
//        User user = userService.getUserByLogin(userLogin);
//
//        Map<String, Object> taskListData = taskService.getTaskListData(user, page, size, yearMonth);
//        List<CompanyForTaskDto> companiesList = (List<CompanyForTaskDto>) taskListData.get("companyDtos");
//        if (companiesList == null || companiesList.isEmpty()) {
//            model.addAttribute("errorMsg", "У вас нет компаний");
//        }
//        List<String> availableYearMonths = taskService.getAllYearMonths(authentication.getName());
//
//
//        List<TaskStatusDto> taskStatusDtos = taskStatusService.getAllTaskStatuses();
//        ObjectMapper objectMapper = new ObjectMapper();
//        String taskStatusDtosJson = objectMapper.writeValueAsString(taskStatusDtos);
//
//        String availableYearMonthsJson = objectMapper.writeValueAsString(availableYearMonths);
//
//        List<DocumentTypeDto> documentTypeDtos = documentTypeService.getFilteredDocumentTypes();
//        List<UserDto> userDtos = userService.getAllUsers();
//        List<CompanyDto> companyDtos = companyService.getAllCompanies();
//
//        model.addAllAttributes(taskListData);
//
//        model.addAttribute("availableYearMonthsJson", availableYearMonthsJson);
//        model.addAttribute("taskStatusDtosJson", taskStatusDtosJson);
//        model.addAttribute("dateUtils", new DateUtils());
//
//        model.addAttribute("userDtos", userDtos);
//        model.addAttribute("companyDtos", companyDtos);
//        model.addAttribute("taskStatusDtos", taskStatusDtos);
//        model.addAttribute("documentTypeDtos", documentTypeDtos);
//        model.addAttribute("taskCreateDto", new TaskCreateDto());
//
//        System.out.println("availableYearMonths: " + availableYearMonths);
//        System.out.println("taskListData: " + taskListData);
//
//        System.out.println("Json task statuses: " + taskStatusDtosJson);
//        System.out.println("Json year month: " + availableYearMonths);
//
//        model.addAttribute("openModal", openModal);
//
//        return "tasks/tasksList";
//    }
//
//    @PostMapping("/edit/{id}")
//    @ResponseBody
//    public ResponseEntity<?> updateTaskInListPage(
//            @Valid @ModelAttribute("taskDto") TaskForTaskListEditDto taskDto,
//            @PathVariable Long id,
//            Authentication authentication
//    ) {
//        if (!taskService.checkIsAuthor(authentication.getName(), id)) {
//            return ResponseEntity.status(HttpStatus.FORBIDDEN)
//                    .body(Map.of("error", "Вы не имеете прав редактировать эту задачу!"));
//        }
//
//        if (!taskService.areValidDates(taskDto.getFrom(), taskDto.getTo())) {
//            return ResponseEntity.badRequest()
//                    .body(Map.of("error", "Выбраны неправильные даты!"));
//        }
//
//        taskService.editTaskFromTasksList(taskDto, authentication.getName(), id);
//        return ResponseEntity.ok(Map.of("success", "Успешно обновлено!"));
//    }
//
//
//    @PostMapping("/{taskId}/priority")
//    public ResponseEntity<String> updateTaskPriority(@PathVariable Long taskId, @RequestParam Long priorityId) {
//        System.out.println("Task ID: " + taskId + ", Priority ID: " + priorityId);
//        taskService.updateTaskPriority(taskId, priorityId);
//        return ResponseEntity.ok("Priority updated successfully");
//    }
//
//    @PostMapping("/tag")
//    public ResponseEntity<Void> createTag(@RequestBody TagDto tagDto, Authentication authentication) {
//        String login = authentication.getName();
//        User user = userService.getUserByLogin(login);
//
//        if (user == null) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
//        }
//
//        tagDto.setUserId(user.getId());
//        tagService.createTag(tagDto);
//
//        return ResponseEntity.ok().build();
//    }
//
//    @GetMapping("/tags/user")
//    @ResponseBody
//    public List<TagDto> getUserTags(Authentication authentication) {
//        String login = authentication.getName();
//        User userDto = userService.getUserByLogin(login);
//
//        if (userDto == null) {
//            throw new NoSuchElementException("User not found");
//        }
//
//        return tagService.getTagsByUserId(userDto.getId());
//    }
//
//    @GetMapping("/{taskId}/tag")
//    public ResponseEntity<TagDto> getTaskTag(@PathVariable Long taskId) {
//        TagDto tag = tagService.getTagForTask(taskId);
//        if (tag == null) {
//            return ResponseEntity.notFound().build();
//        }
//        return ResponseEntity.ok(tag);
//    }
//
//    @PostMapping("/tag/update")
//    public ResponseEntity<Void> updateTag(@RequestBody TagUpdateDto tagUpdateDto, Authentication authentication) {
//        String login = authentication.getName();
//        User user = userService.getUserByLogin(login);
//
//        if (user == null) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
//        }
//
//        tagService.updateTagForTask(tagUpdateDto.getTaskId(), tagUpdateDto.getTagId());
//
//        return ResponseEntity.ok().build();
//    }
//}