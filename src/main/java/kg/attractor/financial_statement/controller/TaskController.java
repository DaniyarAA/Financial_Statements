package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.DocumentTypeDto;
import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.dto.TaskDto;
import kg.attractor.financial_statement.service.DocumentTypeService;
import kg.attractor.financial_statement.service.TaskService;
import kg.attractor.financial_statement.utils.DateUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("tasks")
public class TaskController {
    private final TaskService taskService;
    private final DocumentTypeService documentTypeService;

    @GetMapping
    public String getTasks(Model model) {
        List<TaskDto> tasks = taskService.getAllTasks();

        model.addAttribute("tasks", tasks);
        model.addAttribute("dateUtils", new DateUtils());
        return "tasks/tasksMain";
    }

    @GetMapping("create")
    public String getCreateTaskForm(
            Model model,
            Authentication authentication
    ) {
        List<DocumentTypeDto> documentTypeDtos = documentTypeService.getAllDocumentTypes();
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
        return "redirect:/tasks/" + id;

    }
}
