package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.dto.TaskDto;
import kg.attractor.financial_statement.dto.TaskEditDto;
import kg.attractor.financial_statement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Map;

public interface TaskService {
    TaskDto getTaskById(Long id);

    List<TaskDto> getAllTasks();

    Long createTask(TaskCreateDto taskCreateDto, String name);

    ResponseEntity<Map<LocalDate, Long>> countOfTaskForDay(Map<String, Integer> yearMonth);

    Page<TaskDto> getTasksPage(int page, int size, String sort, String direction, Long documentTypeId, Long statusId);

    void editTask(Long id, TaskEditDto taskEditDto);

    void deleteTask(Long id);

    List<TaskDto> getTaskDtosForUserAndMonth(User user, Integer month);

    List<TaskDto> getAllTasksForUser(User user);

    List<TaskDto> getTaskDtosForUserAndYearMonth(User user, YearMonth selectedMonthYear);

    TaskDto getTaskDtoById(Long taskId);

    ResponseEntity<Map<String, String>> editTaskByField(Map<String, String> data);

    Map<String, Object> getTaskListData(User user, int page, int size);

    void editTaskFromTasksList(TaskEditDto taskEditDto, String name, Long id);

    boolean checkIsAuthor(String name, Long id);
}
