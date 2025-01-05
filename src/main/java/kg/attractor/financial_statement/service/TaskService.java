package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.*;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.Tag;
import kg.attractor.financial_statement.entity.Task;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.enums.ReportFrequency;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;

import java.security.Principal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Map;

public interface TaskService {
    TaskDto getTaskById(Long id);

    List<TaskDto> getAllTasks();

    Long createTask(TaskCreateDto taskCreateDto, String name);

    ResponseEntity<Map<LocalDate, Long>> countOfTaskForDay(Map<String, Integer> yearMonth, Principal principal);

    Page<TaskDto> getTasksPage(int page, int size, String sort, String direction, Long documentTypeId, Long statusId);

    void editTask(Long id, TaskEditDto taskEditDto);

    void deleteTask(Long id);

    List<TaskDto> getTaskDtosForUserAndMonth(User user, Integer month);

    List<TaskDto> getAllTaskDtosForUser(User user);

    List<TaskDto> getAllTasksForUserSorted(User user, String sortDirection, String sortBy);

    List<TaskDto> getTaskDtosForUserAndYearMonth(User user, YearMonth selectedMonthYear);

    TaskDto getTaskDtoById(Long taskId);

    Map<String, Object> getTaskListData(User user, int page, int size, String paramYearMonth);

    void editTaskFromTasksList(TaskForTaskListEditDto taskEditDto, String name, Long id);

    boolean checkIsAuthor(String name, Long id);

    @Scheduled(cron = "0 0 0 1 1 *")
    void tasksGenerator();

    void generateAutomaticTasks(Company userCompany, LocalDate currentDate, ReportFrequency frequency);

    List<Task> findByCompanyAndDate(Long companyId, LocalDate startDate, LocalDate endDate);

    void updateTaskPriority(Long taskId, Long priorityId);

    void updateTaskTag(Long taskId, Tag tag);

    List<String> getAllYearMonths(String login);

    List<TaskDto> getAllFinishedTasks();

    List<TaskDto> getFinishedTasksForUser(Long userId);

    void updateTaskStatus(Long taskId, Long newStatusId);

    boolean areValidDates(String from, String to);

    List <TaskDto> getTasksByCompanyId(Long id);

    List<TaskDto> getTasksByUsers_IdAndCompany_Id(Long userId, Long companyId);

    List<TaskDto> getTasksForUser(Long userId);
}