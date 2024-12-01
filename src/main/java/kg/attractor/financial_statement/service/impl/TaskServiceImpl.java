package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.*;
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
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.*;
import java.util.function.Function;
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
    public ResponseEntity<Map<LocalDate, Long>> countOfTaskForDay(Map<String, Integer> yearMonth) {
        int year = yearMonth.get("year");
        int month = yearMonth.get("month");
        YearMonth ym = YearMonth.of(year, month);
        List<Task> tasks = taskRepository.findAll();

        Map<LocalDate, Long> calendarTaskCount = tasks.stream()
                .map(Task::getEndDate)
                .filter(date -> YearMonth.from(date).equals(ym))
                .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

        return ResponseEntity.ok().body(calendarTaskCount);
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

        Task task = (taskCreateDto.getAppointToUserId() != null) ? convertToEntity(taskCreateDto) : convertToEntity(taskCreateDto, login);
        Task newTask = taskRepository.save(task);
        return newTask.getId();
    }

    @Override
    @Scheduled(cron = "0 0 0 1 1 *")
    public void tasksGenerator() {
        LocalDate currentDate = LocalDate.now();

        if (currentDate.getMonthValue() == 1 && currentDate.getDayOfMonth() == 1) {
            List<Company> companies = companyService.findAll();

            for (Company company : companies) {

                List<UserCompany> userCompanies = userCompanyService.findByCompanyAndIsAutomatic(company, true);

                for (UserCompany userCompany : userCompanies) {
                    generateAutomaticTasks(userCompany, currentDate);
                }
            }
        }
    }

    @Override
    public void generateAutomaticTasks(UserCompany userCompany, LocalDate currentDate) {
        int currentYear = currentDate.getYear();

        List<DocumentType> automaticDocumentTypes = documentTypeService.getNonOptionalDocumentTypes();
        TaskStatus defaultStatus = taskStatusService.getTaskStatusById(1L);
        userCompany.setIsAutomatic(true);

        for (int i = 0; i < 12; i++) {
            YearMonth nextMonth = YearMonth.of(currentYear, currentDate.getMonthValue()).plusMonths(i);

            if (nextMonth.getYear() == currentYear) {
                for (DocumentType documentType : automaticDocumentTypes) {
                    Task task = new Task();
                    LocalDate startDate = nextMonth.atDay(1);
                    LocalDate endDate = nextMonth.atEndOfMonth();
                    task.setUserCompany(userCompany);
                    task.setStartDate(startDate);
                    task.setEndDate(endDate);
                    task.setDocumentType(documentType);
                    task.setTaskStatus(defaultStatus);
                    taskRepository.save(task);
                }
            }
        }
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

    @Override
    public Map<String, Object> getTaskListData(User user, int page, int size, String paramYearMonth) {
        YearMonth filterYearMonth = getFilterYearMonth(paramYearMonth);
        YearMonth previousYearMonth = filterYearMonth.minusMonths(1);

        List<CompanyForTaskDto> companyDtos = companyService.getAllCompaniesForUser(user);
        List<TaskDto> taskDtos = getAllTasksForUser(user);

        List<TaskDto> filteredTasks = filterTasksByYearMonth(taskDtos, filterYearMonth, previousYearMonth);
        Map<String, String> monthsMap = mapYearMonthsToReadableFormat(filteredTasks);

        Map<String, Map<String, List<TaskDto>>> tasksByYearMonthAndCompany = groupTasksByYearMonthAndCompany(
                filteredTasks, companyDtos);

        return buildResponse(page, size, companyDtos, monthsMap, tasksByYearMonthAndCompany);
    }


    @Override
    public void editTaskFromTasksList(TaskForTaskListEditDto taskDto, String name, Long id) {
        Task newVersionOfTask = taskRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Task not found for id: " + id));
        if (taskDto.getStatusId() != null) {
            newVersionOfTask.setTaskStatus(taskStatusService.getTaskStatusById(taskDto.getStatusId()));
        }
        if (taskDto.getAmount() != null) {
            String cleanedValue = taskDto.getAmount().replaceAll("[,\\s]", "");
            if (isValidBigDecimal(cleanedValue)) {
                newVersionOfTask.setAmount(new BigDecimal(cleanedValue));
            }
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
        task.setStartDate(taskCreateDto.getStartDate());
        task.setEndDate(taskCreateDto.getEndDate());
        task.getUserCompany().setIsAutomatic(false);

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
        task.getUserCompany().setIsAutomatic(false);

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

    private YearMonth getFilterYearMonth(String paramYearMonth) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");
        return (paramYearMonth == null || paramYearMonth.isEmpty())
                ? YearMonth.now()
                : YearMonth.parse(paramYearMonth, formatter);
    }

    private List<TaskDto> filterTasksByYearMonth(List<TaskDto> tasks, YearMonth filterYearMonth, YearMonth previousYearMonth) {
        return tasks.stream()
                .filter(task -> {
                    YearMonth taskYearMonth = YearMonth.from(task.getStartDate());
                    return taskYearMonth.equals(filterYearMonth) || taskYearMonth.equals(previousYearMonth);
                })
                .collect(Collectors.toList());
    }

    private Map<String, String> mapYearMonthsToReadableFormat(List<TaskDto> tasks) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");
        return tasks.stream()
                .map(task -> YearMonth.from(task.getStartDate()).format(formatter))
                .distinct()
                .collect(Collectors.toMap(
                        ym -> ym,
                        ym -> YearMonth.parse(ym, formatter)
                                      .getMonth()
                                      .getDisplayName(TextStyle.FULL, new Locale("ru")) + " " + YearMonth.parse(ym, formatter).getYear(),
                        (oldValue, newValue) -> oldValue,
                        LinkedHashMap::new
                ));
    }

    private Map<String, Map<String, List<TaskDto>>> groupTasksByYearMonthAndCompany(
            List<TaskDto> tasks, List<CompanyForTaskDto> companies) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");
        Set<String> uniqueYearMonths = tasks.stream()
                .map(task -> YearMonth.from(task.getStartDate()).format(formatter))
                .collect(Collectors.toSet());

        Map<String, Map<String, List<TaskDto>>> tasksByYearMonthAndCompany = new LinkedHashMap<>();
        for (String yearMonth : uniqueYearMonths) {
            Map<String, List<TaskDto>> tasksForCompanies = new HashMap<>();
            for (CompanyForTaskDto company : companies) {
                List<TaskDto> tasksForCompanyAndMonth = tasks.stream()
                        .filter(task -> YearMonth.from(task.getStartDate()).format(formatter).equals(yearMonth)
                                        && task.getCompany().getId().equals(company.getId()))
                        .collect(Collectors.toList());
                tasksForCompanies.put(company.getId().toString(), tasksForCompanyAndMonth);
            }
            tasksByYearMonthAndCompany.put(yearMonth, tasksForCompanies);
        }
        return tasksByYearMonthAndCompany;
    }

    private Map<String, Object> buildResponse(int page, int size, List<CompanyForTaskDto> companyDtos,
                                              Map<String, String> monthsMap,
                                              Map<String, Map<String, List<TaskDto>>> tasksByYearMonthAndCompany) {
        int totalCompanies = companyDtos.size();
        int start = page * size;
        int end = Math.min(start + size, totalCompanies);
        List<CompanyForTaskDto> paginatedCompanies = companyDtos.subList(start, end);

        Map<String, Object> response = new HashMap<>();
        response.put("currentPage", page);
        response.put("totalPages", (int) Math.ceil((double) totalCompanies / size));
        response.put("list", paginatedCompanies);
        response.put("monthsMap", monthsMap);
        response.put("companyDtos", companyDtos);
        response.put("tasksByYearMonthAndCompany", tasksByYearMonthAndCompany);
        return response;
    }

    @Override
    public List<TaskDto> getAllFinishedTasks() {
        return taskRepository.findAllByTaskStatus(taskStatusService.getStatusDone())
                .stream()
                .map(this::convertToDto)
                .toList();
    }

    @Override
    public List<TaskDto> getFinishedTasksForUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.getUserByLogin(authentication.getName());
        TaskStatus taskStatus = taskStatusService.getStatusDone();
        return taskRepository.findAllByUserCompany_UserAndTaskStatus(user, taskStatus)
                .stream()
                .map(this::convertToDto)
                .toList();
    }

    @Override
    public void updateTaskStatus(Long taskId, Long newStatusId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task not found: " + taskId));
        task.setTaskStatus(taskStatusService.getTaskStatusById(newStatusId));
        taskRepository.save(task);
    }
}