package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TaskStatusDto;
import kg.attractor.financial_statement.entity.TaskStatus;
import kg.attractor.financial_statement.repository.TaskStatusRepository;
import kg.attractor.financial_statement.service.TaskStatusService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskStatusServiceImpl implements TaskStatusService {
    private final TaskStatusRepository taskStatusRepository;

    @Override
    public List<TaskStatusDto> getAllTaskStatuses() {
        List<TaskStatus> taskStatuses = taskStatusRepository.findAll();
        return convertToDtoList(taskStatuses);
    }

    @Override
    public TaskStatus getTaskStatusById(Long statusId) {
        return taskStatusRepository.findById(statusId)
                .orElseThrow(() -> new NoSuchElementException("Task status not found: " + statusId));
    }

    @Override
    public Boolean getIsCompleted(TaskStatus taskStatus) {
        return taskStatus.getName().equals("Сдан");
    }

    private List<TaskStatusDto> convertToDtoList(List<TaskStatus> taskStatuses) {
        return taskStatuses.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    private TaskStatusDto convertToDto (TaskStatus taskStatus) {
        return TaskStatusDto.builder()
                .id(taskStatus.getId())
                .name(taskStatus.getName())
                .build();
    }

    @Override
    public TaskStatus getStatusDone() {
        return taskStatusRepository.findByName("Сдан");
    }
}
