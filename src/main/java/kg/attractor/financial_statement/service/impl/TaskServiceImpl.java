package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.*;
import kg.attractor.financial_statement.entity.Task;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.enums.ReportFrequency;
import kg.attractor.financial_statement.enums.TaskPriority;
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
import java.security.Principal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Map;
import java.util.function.Function;
import java.time.format.TextStyle;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;
    private final TaskPageableRepository taskPageableRepository;
    private final UserService userService;
    private final DocumentTypeServiceImpl documentTypeService;
    //    private final UserCompanyService userCompanyService;
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
    public ResponseEntity<Map<LocalDate, Long>> countOfTaskForDay(Map<String, Integer> yearMonth, Principal principal) {
        if (principal == null || principal.getName().isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        User user = userService.getUserByLogin(principal.getName());

        List<Company> companies = companyService.findByUser(user);

        int year = yearMonth.get("year");
        int month = yearMonth.get("month");
        YearMonth ym = YearMonth.of(year, month);

        List<Task> tasks = taskRepository.findAll().stream()
                .filter(task -> companies.contains(task.getCompany()))
                .toList();

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
    public List<TaskDto> getAllTaskDtosForUser(User user) {

        if (user == null) {
            throw new IllegalArgumentException("Пользователь не может быть null");
        }

        List<Company> companies = companyService.findByUser(user);
        List<Task> tasks = taskRepository.findByCompanyIn(companies);
        return convertToDtoList(tasks);
    }

    @Override
    public List<TaskDto> getAllTasksForUserSorted(User user, String sortBy, String sort) {
        if (user == null) {
            throw new IllegalArgumentException("Пользователь не может быть null");
        }

        List<Company> companies = companyService.findByUser(user);

        Sort.Direction direction = "asc".equalsIgnoreCase(sort) ? Sort.Direction.ASC : Sort.Direction.DESC;

        List<Task> tasks = taskRepository.findByCompanyIn(companies, Sort.by(direction, sortBy));

        return convertToDtoList(tasks);
    }

    private List<Task> getAllTasksForUser(User user) {
        if (user == null) {
            throw new IllegalArgumentException("Пользователь не может быть null");
        }

        List<Company> companies = companyService.findByUser(user);

        return taskRepository.findByCompanyIn(companies);
    }

    @Override
    public List<TaskDto> getTaskDtosForUserAndYearMonth(User user, YearMonth selectedMonthYear) {
        if (user == null || selectedMonthYear == null) {
            throw new IllegalArgumentException("Пользователь и месяц/год не могут быть null");
        }

        List<Company> companies = companyService.findByUser(user);

        List<Task> tasks = taskRepository.findByCompanyInAndStartDatetimeYearAndStartDatetimeMonth(
                companies,
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

                if (company.isDeleted()) {
                    continue;
                }

                ReportFrequency frequency = company.getReportFrequency();

                List<UserCompany> userCompanies = userCompanyService.findByCompanyAndIsAutomatic(company, true);

                for (UserCompany userCompany : userCompanies) {
                    generateAutomaticTasks(userCompany, currentDate, frequency);
                }
            }
        }
    }

    @Override
    public void generateAutomaticTasks(UserCompany userCompany, LocalDate currentDate, ReportFrequency frequency) {
        int currentYear = currentDate.getYear();
        List<DocumentType> automaticDocumentTypes = documentTypeService.getNonOptionalDocumentTypes();
        TaskStatus defaultStatus = taskStatusService.getTaskStatusById(1L);
        DocumentType enReport = documentTypeService.getDocumentTypeById(2L);
        DocumentType nspReport = documentTypeService.getDocumentTypeById(14L);

        for (int i = 0; i < 12; i++) {
            YearMonth nextMonth = YearMonth.of(currentYear, currentDate.getMonthValue()).plusMonths(i);

            if (nextMonth.getYear() == currentYear) {
                for (DocumentType documentType : automaticDocumentTypes) {
                    if (documentType.getId().equals(enReport.getId())) {
                        continue;
                    }

                    if (documentType.getId().equals(nspReport.getId()) && frequency == ReportFrequency.QUARTERLY) {
                        continue;
                    }

                    LocalDate startDate = nextMonth.atDay(1);
                    LocalDate endDate = nextMonth.atEndOfMonth();

                    Task task = new Task();
                    task.setUserCompany(userCompany);
                    task.setStartDate(startDate);
                    task.setEndDate(endDate);
                    task.setDocumentType(documentType);
                    task.setTaskStatus(defaultStatus);
                    taskRepository.save(task);
                }
            }
        }

        int currentQuarter = (currentDate.getMonthValue() - 1) / 3 + 1;

        if (currentDate.getMonthValue() == 1 && currentDate.getDayOfMonth() == 1) {
            for (int quarter = 1; quarter <= 4; quarter++) {
                YearMonth quarterStartMonth = YearMonth.of(currentYear, (quarter - 1) * 3 + 1);
                LocalDate startDate = quarterStartMonth.atDay(1);
                LocalDate endDate = quarterStartMonth.plusMonths(2).atEndOfMonth();

                Task enTask = new Task();
                enTask.setUserCompany(userCompany);
                enTask.setStartDate(startDate);
                enTask.setEndDate(endDate);
                enTask.setDocumentType(enReport);
                enTask.setTaskStatus(defaultStatus);
                taskRepository.save(enTask);

                if (frequency == ReportFrequency.QUARTERLY) {
                    Task nspTask = new Task();
                    nspTask.setUserCompany(userCompany);
                    nspTask.setStartDate(startDate);
                    nspTask.setEndDate(endDate);
                    nspTask.setDocumentType(nspReport);
                    nspTask.setTaskStatus(defaultStatus);
                    taskRepository.save(nspTask);
                }
            }
        } else {
            YearMonth quarterStartMonth = YearMonth.of(currentYear, (currentQuarter - 1) * 3 + 1);
            LocalDate startDate = quarterStartMonth.atDay(1);
            LocalDate endDate = quarterStartMonth.plusMonths(2).atEndOfMonth();

            Task enTask = new Task();
            enTask.setUserCompany(userCompany);
            enTask.setStartDate(startDate);
            enTask.setEndDate(endDate);
            enTask.setDocumentType(enReport);
            enTask.setTaskStatus(defaultStatus);
            taskRepository.save(enTask);

            if (frequency == ReportFrequency.QUARTERLY) {
                Task nspTask = new Task();
                nspTask.setUserCompany(userCompany);
                nspTask.setStartDate(startDate);
                nspTask.setEndDate(endDate);
                nspTask.setDocumentType(nspReport);
                nspTask.setTaskStatus(defaultStatus);
                taskRepository.save(nspTask);
            }
        }
    }

    @Override
    public List<String> getAllYearMonths(String login) {
        User user = userService.getUserByLogin(login);
        List<Task> tasks = getAllTasksForUser(user);
        List<String> yearMonths = tasks.stream()
                .map(Task::getStartDate)
                .map(date -> date.format(DateTimeFormatter.ofPattern("MM.yyyy")))
                .distinct()
                .sorted(Comparator.comparing(
                        yearMonth -> YearMonth.parse(yearMonth, DateTimeFormatter.ofPattern("MM.yyyy"))
                ))
                .toList();

        if (yearMonths.isEmpty()) {
            String currentYearMonth = YearMonth.now().format(DateTimeFormatter.ofPattern("MM.yyyy"));
            yearMonths = List.of(currentYearMonth);
        }

        return yearMonths;
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
        YearMonth nextYearMonth = filterYearMonth.plusMonths(1);

        List<CompanyForTaskDto> companyDtos = companyService.getAllCompaniesForUser(user);
        List<TaskDto> taskDtos = getAllTaskDtosForUser(user);

        List<TaskDto> filteredTasks = filterTasksByYearMonth(taskDtos, filterYearMonth, nextYearMonth);
        Map<String, String> monthsMap = mapYearMonthsToReadableFormat(filteredTasks, paramYearMonth);

        Map<String, Map<String, List<TaskDto>>> tasksByYearMonthAndCompany = groupTasksByYearMonthAndCompany(
                filteredTasks, companyDtos);

        List<String> availableYearMonths = new ArrayList<>(tasksByYearMonthAndCompany.keySet());

        Collections.sort(availableYearMonths);

        System.out.println("Tasks Map: " + tasksByYearMonthAndCompany);

        System.out.println("Month map: " + monthsMap);

        Map<String, Object> response = buildResponse(page, size, companyDtos, monthsMap, tasksByYearMonthAndCompany);
        response.put("availableYearMonths", availableYearMonths);
        return response;
    }


    @Override
    public void editTaskFromTasksList(TaskForTaskListEditDto taskDto, String name, Long id) {
        System.out.println("TaskEditDto: " + taskDto.getFrom() + " " + taskDto.getTo());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
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
        if (taskDto.getFrom() != null) {
            LocalDate startDate = LocalDate.parse(taskDto.getFrom(), formatter);
            newVersionOfTask.setStartDate(startDate);
        }
        if (taskDto.getTo() != null) {
            LocalDate endDate = LocalDate.parse(taskDto.getTo(), formatter);
            newVersionOfTask.setEndDate(endDate);
        }
        newVersionOfTask.setId(id);
        taskRepository.save(newVersionOfTask);

    }

    @Override
    public boolean checkIsAuthor(String userLogin, Long taskId) {
        if (userLogin == null || taskId == null) {
            throw new IllegalArgumentException("Login пользователя и ID задачи не могут быть null");
        }
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task not found with id: " + taskId));

        User user = userService.getUserByLogin(userLogin);

        List<Company> userCompanies = companyService.findByUser(user);

        return userCompanies.stream()
                .anyMatch(company -> task.getCompany().equals(company));
    }

    @Override
    public List<Task> findByCompanyAndDate(Long companyId, LocalDate startDate, LocalDate endDate) {
        return taskRepository.findByUserCompany_Company_IdAndEndDateBetween(companyId, startDate, endDate);
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
                .priorityId(task.getPriorityId())
                .priorityColor(TaskPriority.getColorByIdOrDefault(task.getPriorityId() != null ? task.getPriorityId().intValue() : null))
                .tag(task.getTag() != null ? task.getTag().getTag() : null)
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

    private List<TaskDto> filterTasksByYearMonth(List<TaskDto> tasks, YearMonth filterYearMonth, YearMonth nextYearMonth) {
        return tasks.stream()
                .filter(task -> {
                    YearMonth taskYearMonth = YearMonth.from(task.getStartDate());
                    return taskYearMonth.equals(filterYearMonth) || taskYearMonth.equals(nextYearMonth);
                })
                .collect(Collectors.toList());
    }

    private Map<String, String> mapYearMonthsToReadableFormat(List<TaskDto> tasks, String paramYearMonth) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");
        Map<String, String> monthsMap = tasks.stream()
                .sorted(Comparator.comparing(task -> YearMonth.from(task.getStartDate())))
                .map(task -> YearMonth.from(task.getStartDate()).format(formatter))
                .distinct()
                .collect(Collectors.toMap(
                        ym -> ym,
                        ym -> YearMonth.parse(ym, formatter)
                                .getMonth()
                                .getDisplayName(TextStyle.FULL_STANDALONE, new Locale("ru")) + " "
                                + YearMonth.parse(ym, formatter).getYear(),
                        (oldValue, newValue) -> oldValue,
                        LinkedHashMap::new
                ));

        if (paramYearMonth == null || paramYearMonth.trim().isEmpty()) {
            String currentYearMonth = YearMonth.now().format(formatter);
            if (!monthsMap.containsKey(currentYearMonth)) {
                YearMonth currentYM = YearMonth.now();
                monthsMap.put(
                        currentYearMonth,
                        currentYM.getMonth().getDisplayName(TextStyle.FULL_STANDALONE, new Locale("ru")) + " " + currentYM.getYear()
                );
            }
        }

        return monthsMap;
    }

    private Map<String, Map<String, List<TaskDto>>> groupTasksByYearMonthAndCompany(
            List<TaskDto> tasks, List<CompanyForTaskDto> companies) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");

        List<String> sortedYearMonths = tasks.stream()
                .map(task -> YearMonth.from(task.getStartDate()).format(formatter))
                .distinct()
                .sorted(Comparator.comparing(yearMonth -> YearMonth.parse(yearMonth, formatter)))
                .toList();

        Map<String, Map<String, List<TaskDto>>> tasksByYearMonthAndCompany = new LinkedHashMap<>();
        for (String yearMonth : sortedYearMonths) {
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
    public void updateTaskPriority(Long taskId, Long priorityId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task not found"));

        task.setPriorityId(priorityId);
        taskRepository.save(task);
    }

    @Override
    public void updateTaskTag(Long taskId, Tag tag) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task not found"));

        task.setTag(tag);
        taskRepository.save(task);
    }

    @Override
    public List<TaskDto> getAllFinishedTasks() {
        return taskRepository.findAllByTaskStatus(taskStatusService.getStatusDone())
                .stream()
                .map(this::convertToDtoForGetFinishedTasks)
                .toList();
    }

    @Override
    public List<TaskDto> getFinishedTasksForUser(Long userId) {
        TaskStatus taskStatus = taskStatusService.getStatusDone();
        return taskRepository.findAllByUserCompany_UserAndTaskStatus(userService.getUserById(userId), taskStatus)
                .stream()
                .map(this::convertToDtoForGetFinishedTasks)
                .toList();
    }

    private TaskDto convertToDtoForGetFinishedTasks(Task task) {
        return TaskDto.builder()
                .id(task.getId())
                .statusId(task.getTaskStatus().getName())
                .startDate(task.getStartDate())
                .endDate(task.getEndDate())
                .documentTypeName(documentTypeService.getDocumentName(task.getDocumentType().getId()))
                .company(companyService.getCompanyForTaskDto(task.getUserCompany().getCompany().getId()))
                .amount(task.getAmount())
                .description(task.getDescription())
                .build();
    }

    @Override
    public void updateTaskStatus(Long taskId, Long newStatusId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new NoSuchElementException("Task not found: " + taskId));
        task.setTaskStatus(taskStatusService.getTaskStatusById(newStatusId));
        taskRepository.save(task);
    }

    @Override
    public boolean areValidDates(String from, String to) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");

        try {
            LocalDate fromDate = LocalDate.parse(from, formatter);
            LocalDate toDate = LocalDate.parse(to, formatter);

            if (fromDate.getYear() < 2010 || fromDate.getYear() > 2050
                    || toDate.getYear() < 2010 || toDate.getYear() > 2050) {
                return false;
            }

            if (!fromDate.isBefore(toDate)) {
                return false;
            }
        } catch (DateTimeParseException e) {
            return false;
        }

        return true;
    }
}