package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.dto.TaskDto;
import org.springframework.data.domain.Page;

import java.util.List;

public interface TaskService {
    List<TaskDto> getAllTasks();

    Long createTask(TaskCreateDto taskCreateDto, String name);

    Page<TaskDto> getTasksPage(int page, int size, String sort, String direction, Long documentTypeId, Long statusId);
}
