package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TaskDto;

import java.util.List;

public interface TaskService {
    List<TaskDto> getAllTasks();
}