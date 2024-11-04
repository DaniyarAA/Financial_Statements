package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.dto.TaskDto;
import kg.attractor.financial_statement.entity.Task;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
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

import java.time.LocalDate;
import java.time.YearMonth;
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
    public List<TaskDto> getTaskDtosForUserAndMonth(User user, Integer month) {
        return null;
    }

    @Override
    public List<TaskDto> getAllTasksForUser(User user) {
        List<Long> userCompanyIds = userCompanyService.findUserCompanyIdsForUser(user);

        List<Task> tasks = taskRepository.findByUserCompanyIdIn(userCompanyIds);
        return convertToDtoList(tasks);
    }

    @Override
    public List<TaskDto> getTaskDtosForUserAndYearMonth(User user, YearMonth selectedMonthYear) {
        List<Long> userCompanyIds = userCompanyService.findUserCompanyIdsForUser(user);

        List<Task> tasks = taskRepository.findByUserCompanyIdInAndStartDatetimeYearAndMonth(
                userCompanyIds,
                selectedMonthYear.getYear(),
                selectedMonthYear.getMonthValue()
        );

        return convertToDtoList(tasks);
    }

    @Override
    public TaskDto getTaskDtoById(Long taskId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task now found for id: " + taskId));
        return convertToDto(task);
    }


    @Override
    public Long createTask(TaskCreateDto taskCreateDto, String login) {
        System.out.println("login: " + taskCreateDto.getAppointToUserId());
        LocalDate now = LocalDate.now();

        if (taskCreateDto.getDocumentTypeId().equals(1L)) {
            if (now.getDayOfMonth() == 1) {
                taskCreateDto.setStartDateTime(now.atStartOfDay());
                LocalDate lastDayOfCurrentMonthDate = now.withDayOfMonth(now.lengthOfMonth());
                taskCreateDto.setEndDateTime(lastDayOfCurrentMonthDate.atTime(23, 59, 59));
            } else {
                LocalDate firstDayOfNextMonth = now.plusMonths(1).withDayOfMonth(1);
                taskCreateDto.setStartDateTime(firstDayOfNextMonth.atStartOfDay());
                LocalDate lastDayOfNextMonthDate = firstDayOfNextMonth.withDayOfMonth(firstDayOfNextMonth.lengthOfMonth());
                taskCreateDto.setEndDateTime(lastDayOfNextMonthDate.atTime(23, 59, 59));
            }
        }

        else if (taskCreateDto.getDocumentTypeId().equals(2L)) {
            int currentQuarter = (now.getMonthValue() - 1) / 3 + 1;
            LocalDate quarterStart;

            if (now.getDayOfMonth() == 1) {
                quarterStart = now.withMonth((currentQuarter - 1) * 3 + 1).withDayOfMonth(1);
            } else {
                currentQuarter = currentQuarter == 4 ? 1 : currentQuarter + 1;
                quarterStart = LocalDate.of(now.getYear() + (currentQuarter == 1 ? 1 : 0), (currentQuarter - 1) * 3 + 1, 1);
            }
            LocalDate quarterEnd = quarterStart.plusMonths(2).withDayOfMonth(quarterStart.plusMonths(2).lengthOfMonth());
            taskCreateDto.setStartDateTime(quarterStart.atStartOfDay());
            taskCreateDto.setEndDateTime(quarterEnd.atTime(23, 59, 59));
        }

        else if (taskCreateDto.getDocumentTypeId().equals(13L)) {
            if (now.getDayOfMonth() == 1) {
                taskCreateDto.setStartDateTime(now.atStartOfDay());
                LocalDate lastDayOfCurrentMonthDate = now.withDayOfMonth(now.lengthOfMonth());
                taskCreateDto.setEndDateTime(lastDayOfCurrentMonthDate.atTime(23, 59, 59));
            } else {
                LocalDate firstDayOfNextMonth = now.plusMonths(1).withDayOfMonth(1);
                taskCreateDto.setStartDateTime(firstDayOfNextMonth.atStartOfDay());
                LocalDate lastDayOfNextMonthDate = firstDayOfNextMonth.withDayOfMonth(firstDayOfNextMonth.lengthOfMonth());
                taskCreateDto.setEndDateTime(lastDayOfNextMonthDate.atTime(23, 59, 59));
            }
        }

        Task task = (taskCreateDto.getAppointToUserId() != null) ? convertToEntity(taskCreateDto) : convertToEntity(taskCreateDto, login);
        Task newTask = taskRepository.save(task);
        return newTask.getId();
    }

    private Task convertToEntity(TaskCreateDto taskCreateDto, String login) {
        Task task = new Task();
        task.setDocumentType(documentTypeService.getDocumentTypeById(taskCreateDto.getDocumentTypeId()));
        task.setUserCompany(userCompanyService.findUserCompanyByTaskCreateDtoAndLogin(taskCreateDto, login));
        task.setTaskStatus(taskStatusService.getTaskStatusById(taskCreateDto.getTaskStatusId()));
        task.setDescription(taskCreateDto.getDescription());
        task.setStartDateTime(taskCreateDto.getStartDateTime());
        task.setEndDateTime(taskCreateDto.getEndDateTime());

        return task;
    }

    private Task convertToEntity(TaskCreateDto taskCreateDto) {
        Task task = new Task();
        task.setDocumentType(documentTypeService.getDocumentTypeById(taskCreateDto.getDocumentTypeId()));
        task.setUserCompany(userCompanyService.findUserCompanyByTaskCreateDto(taskCreateDto));
        task.setTaskStatus(taskStatusService.getTaskStatusById(taskCreateDto.getTaskStatusId()));
        task.setDescription(taskCreateDto.getDescription());
        task.setStartDateTime(taskCreateDto.getStartDateTime());
        task.setEndDateTime(taskCreateDto.getEndDateTime());

        return task;
    }

    private TaskDto convertToDto(Task task) {
        return TaskDto.builder()
                .id(task.getId())
                .statusId(task.getTaskStatus().getName())
                .startDateTime(task.getStartDateTime())
                .endDateTime(task.getEndDateTime())
                .documentTypeName(documentTypeService.getDocumentName(task.getDocumentType().getId()))
                .user(userService.getUserForTaskDto(task.getUserCompany().getUser().getId()))

                .company(companyService.getCompanyForTaskDto(task.getUserCompany().getCompany().getId()))
                .amount(task.getAmount())
                .description(task.getDescription())
                .build();
    }

    private List<TaskDto> convertToDtoList(List<Task> tasks) {
        return tasks.stream().map(this::convertToDto).collect(Collectors.toList());
    }



}