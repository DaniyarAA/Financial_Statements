package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.dto.TaskDto;
import kg.attractor.financial_statement.dto.TaskEditDto;
import kg.attractor.financial_statement.entity.Task;
import kg.attractor.financial_statement.repository.TaskPageableRepository;
import kg.attractor.financial_statement.repository.TaskRepository;
import kg.attractor.financial_statement.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;
    private final TaskPageableRepository taskPageableRepository;
    private final UserService userService;
    private final DocumentTypeServiceImpl documentTypeService;
    private final UserCompanyService userCompanyService;
    private final TaskStatusService taskStatusService;
    private final CompanyService companyService;

    @Override
    public TaskDto getTaskById(Long id) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Task not found"));

        TaskDto taskDto = convertToDto(task);
        taskDto.setDeleted(task.isDeleted());
        return taskDto;
    }

    @Override
    public List<TaskDto> getAllTasks() {
        List<Task> tasks = taskRepository.findAll();
        return tasks.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    @Override
    public Page<TaskDto> getTasksPage(int page, int size, String sort, String direction, Long documentTypeId, Long statusId) {
        Sort.Direction sortDirection = Sort.Direction.fromString(direction);

        Pageable pageable = PageRequest.of(page - 1, size, sortDirection, "id");

        Page<Task> tasksPage;

        if (documentTypeId != null) {
            if (statusId != null) {
                tasksPage = taskPageableRepository.findByDocumentTypeIdAndTaskStatusId(documentTypeId, statusId, pageable);
            } else {
                tasksPage = taskPageableRepository.findByDocumentTypeId(documentTypeId, pageable);
            }
        } else {
            if (statusId != null) {
                tasksPage = taskPageableRepository.findByTaskStatusId(statusId, pageable);
            } else {
                tasksPage = taskPageableRepository.findAll(pageable);
            }
        }
        return tasksPage.map(this::convertToDto);
    }

    @Override
    public Long createTask(TaskCreateDto taskCreateDto, String login) {
        System.out.println("login: " + taskCreateDto.getAppointToUserId());

        Task task = (taskCreateDto.getAppointToUserId() != null) ? convertToEntity(taskCreateDto) : convertToEntity(taskCreateDto, login);
        Task newTask = taskRepository.save(task);
        return newTask.getId();
    }

    @Override
    public void editTask(Long id, TaskEditDto taskEditDto) {
        Task task = taskRepository.findById(id).orElseThrow(() -> new NoSuchElementException("Task not found"));

        if (taskEditDto.getDocumentTypeId() != null) {
            task.setDocumentType(documentTypeService.getDocumentTypeById(taskEditDto.getDocumentTypeId()));
        }
        if (taskEditDto.getStatusId() != null) {
            task.setTaskStatus(taskStatusService.getTaskStatusById(taskEditDto.getStatusId()));
        }
        if (taskEditDto.getDescription() != null) {
            task.setDescription(taskEditDto.getDescription());
        }
        if (taskEditDto.getStartDate() != null) {
            task.setStartDate(taskEditDto.getStartDate());
        }
        if (taskEditDto.getEndDate() != null) {
            task.setEndDate(taskEditDto.getEndDate());
        }
        if (taskEditDto.getAmount() != null) {
            task.setAmount(taskEditDto.getAmount());
        }

        taskRepository.save(task);
    }

    @Override
    public void deleteTask(Long id) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Task not found"));

        task.setDeleted(true);
        taskRepository.save(task);
    }

    private Task convertToEntity(TaskCreateDto taskCreateDto, String login) {
        Task task = new Task();
        task.setDocumentType(documentTypeService.getDocumentTypeById(taskCreateDto.getDocumentTypeId()));
        task.setUserCompany(userCompanyService.findUserCompanyByTaskCreateDtoAndLogin(taskCreateDto, login));
        task.setTaskStatus(taskStatusService.getTaskStatusById(taskCreateDto.getTaskStatusId()));
        task.setDescription(taskCreateDto.getDescription());
        task.setStartDate(taskCreateDto.getStartDate());
        task.setEndDate(taskCreateDto.getEndDate());

        return task;
    }

    private Task convertToEntity(TaskCreateDto taskCreateDto) {
        Task task = new Task();
        task.setDocumentType(documentTypeService.getDocumentTypeById(taskCreateDto.getDocumentTypeId()));
        task.setUserCompany(userCompanyService.findUserCompanyByTaskCreateDto(taskCreateDto));
        task.setTaskStatus(taskStatusService.getTaskStatusById(taskCreateDto.getTaskStatusId()));
        task.setDescription(taskCreateDto.getDescription());
        task.setStartDate(taskCreateDto.getStartDate());
        task.setEndDate(taskCreateDto.getEndDate());

        return task;
    }

    private TaskDto convertToDto(Task task) {
        return TaskDto.builder()
                .id(task.getId())
                .statusId(task.getTaskStatus().getName())
                .startDate(task.getStartDate())
                .endDate(task.getEndDate())
                .documentTypeName(documentTypeService.getDocumentName(task.getDocumentType().getId()))
                .user(userService.getUserForTaskDto(task.getUserCompany().getUser().getId()))

                .company(companyService.getCompanyForTaskDto(task.getUserCompany().getCompany().getId()))
                .amount(task.getAmount())
                .description(task.getDescription())
                .build();
    }
}