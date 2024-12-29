package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TaskStatusDto;
import kg.attractor.financial_statement.entity.TaskStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Map;

public interface TaskStatusService {
    List<TaskStatusDto> getAllTaskStatuses();

    TaskStatus getTaskStatusById(Long statusId);

    Boolean getIsCompleted(TaskStatus taskStatus);

    TaskStatus getStatusDone();

    List<TaskStatusDto> getDefaultTaskStatuses();

    List<TaskStatusDto> getChangeableTaskStatuses();

    ResponseEntity<Map<String, String>> edit(Map<String, String> data,String login);

    ResponseEntity<Map<String, String>> delete(Map<String, String> data, String name);
}
