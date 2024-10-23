package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.dto.TaskDto;
import kg.attractor.financial_statement.entity.Task;
import kg.attractor.financial_statement.repository.TaskRepository;
import kg.attractor.financial_statement.service.TaskService;
import kg.attractor.financial_statement.service.UserCompanyService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;
    private final UserService userService;
    private final DocumentTypeServiceImpl documentTypeService;
    private final UserCompanyService userCompanyService;

    @Override
    public List<TaskDto> getAllTasks() {
        List<Task> tasks = taskRepository.findAll();
        return tasks.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    @Override
    public Long createTask(TaskCreateDto taskCreateDto, String login) {
        LocalDate date = LocalDate.now();
        LocalTime time = LocalTime.now();

        Task task = convertToEntity(taskCreateDto, login, date, time);

        if (task.getUserCompany() != null) {
            //logic
        }
        Task newTask = taskRepository.save(task);
        return newTask.getId();
    }

    private Task convertToEntity(TaskCreateDto taskCreateDto, String login, LocalDate date, LocalTime time) {
        Task task = new Task();
        task.setDocumentType(documentTypeService.getDocumentTypeById(taskCreateDto.getDocumentTypeId()));
        task.setUserCompany(userCompanyService.findUserCompanyByTaskCreateDto(taskCreateDto));
        return task;
    }

    private TaskDto convertToDto(Task task) {
        return TaskDto.builder()
                .id(task.getId())
                .documentTypeName(documentTypeService.getDocumentName(task.getDocumentType().getId()))
                .user(userService.getUserForTaskDto(task.getUserCompany().getUser().getId()))
                .build();
    }
}
