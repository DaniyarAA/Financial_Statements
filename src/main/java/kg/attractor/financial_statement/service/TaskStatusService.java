package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TaskStatusDto;

import java.util.List;

public interface TaskStatusService {
    List<TaskStatusDto> getAllTaskStatuses();
}
