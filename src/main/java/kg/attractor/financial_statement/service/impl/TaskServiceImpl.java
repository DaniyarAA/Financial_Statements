package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyForTaskDto;
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
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.*;
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
    public ResponseEntity<Map<String, String>> editTaskByField(Map<String, String> data) {
        String taskIdStr = data.get("taskId");
        String fieldToEdit = data.get("field");
        String newValue = data.get("value");
        System.out.println("edit " + newValue);

        if (taskIdStr == null || fieldToEdit == null || newValue == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Неправильные вводные данные !"));
        }

        Long taskId;
        try {
            taskId = Long.parseLong(taskIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Нерабочая ID компании !"));
        }

        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task not found for id" + taskId));

        switch (fieldToEdit) {
            case "amount":
                String cleanedValue = newValue.replaceAll("[,\\s]", "");
                if (isValidBigDecimal(cleanedValue)) {
                    task.setAmount(new BigDecimal(cleanedValue));
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Неправильный формат Amount!"));
                }
                break;
            case "description":
                task.setDescription(newValue);
                break;
        }

        taskRepository.save(task);
        return ResponseEntity.ok(Map.of("message", "Задача Успешно отредактирована."));

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

    public Map<String, Object> getTaskListData(User user, int page, int size) {
        List<CompanyForTaskDto> companyDtos = companyService.getAllCompaniesForUser(user);
        List<TaskDto> taskDtos = getAllTasksForUser(user);

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

        Map<String, Object> response = new HashMap<>();
        response.put("currentPage", page);
        response.put("totalPages", (int) Math.ceil((double) totalCompanies / size));
        response.put("list", companyDtos.subList(start, end));
        response.put("monthsMap", monthsMap);
        response.put("companyDtos", companyDtos);
        response.put("tasksByYearMonthAndCompany", tasksByYearMonthAndCompany);

        return response;
    }

    @Override
    public void editTaskFromTasksList(TaskDto taskDto, String name, Long id) {
        Task newVersionOfTask = taskRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Task not found for id: " + id));
        if (taskDto.getStatusId() != null) {
            newVersionOfTask.setTaskStatus(taskStatusService.getTaskStatusById(taskDto.getId()));
        }
        if (taskDto.getAmount() != null) {
            newVersionOfTask.setAmount(taskDto.getAmount());
        }
        if (taskDto.getDescription() != null) {
            newVersionOfTask.setDescription(taskDto.getDescription());
        }
        newVersionOfTask.setId(id);
        taskRepository.save(newVersionOfTask);

    }

    @Override
    public boolean checkIsAuthor(String userLogin, Long taskId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task not found with id: " + taskId));
        User user = userService.getUserByLogin(userLogin);
        return task.getUserCompany().getUser() == user;
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
                .isCompleted(taskStatusService.getIsCompleted(task.getTaskStatus()))
                .build();
    }

    private List<TaskDto> convertToDtoList(List<Task> tasks) {
        return tasks.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    public boolean isValidBigDecimal(String value) {
        if (value == null || value.isEmpty()) {
            return false;
        }
        value = value.replaceAll("[,\\s]", "");
        try {
            new BigDecimal(value);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }




}