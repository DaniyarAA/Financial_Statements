package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TaskStatusDto;
import kg.attractor.financial_statement.entity.TaskStatus;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.enums.Status;
import kg.attractor.financial_statement.repository.TaskStatusRepository;
import kg.attractor.financial_statement.service.TaskStatusService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskStatusServiceImpl implements TaskStatusService {
    private final TaskStatusRepository taskStatusRepository;
    private final UserService userService;

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

    @Override
    public List<TaskStatusDto> getDefaultTaskStatuses() {
       List<String> defaultTaskStatusNames = Arrays.stream(Status.values()).
               map(Status::getTitle).
               toList();
       List<TaskStatus> allTaskStatuses = taskStatusRepository.findAll();
       List<TaskStatus> defaultTaskStatuses = allTaskStatuses.stream().
               filter(taskStatus -> defaultTaskStatusNames.contains(taskStatus.getName())).
               toList();
       return convertToDtoList(defaultTaskStatuses);
    }

    @Override
    public List<TaskStatusDto> getChangeableTaskStatuses() {
        List<String> defaultTaskStatusNames = Arrays.stream(Status.values()).
                map(Status::getTitle).
                toList();
        List<TaskStatus> allTaskStatuses = taskStatusRepository.findAll();
        List<TaskStatus> defaultTaskStatuses = allTaskStatuses.stream().
                filter(taskStatus -> !defaultTaskStatusNames.contains(taskStatus.getName())).
                toList();
        return convertToDtoList(defaultTaskStatuses);
    }

    @Override
    public ResponseEntity<Map<String, String>> edit(Map<String, String> data, String login) {
        String taskStatusIdStr = data.get("taskStatusId");
        String fieldToEdit = data.get("field");
        String newValue = data.get("value");

        if (taskStatusIdStr == null || fieldToEdit == null || newValue == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Неправильные вводные данные !"));
        }

        long taskStatusId;
        try {
            taskStatusId = Long.parseLong(taskStatusIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Нерабочая ID статуса !"));
        }

        TaskStatus taskStatus = getTaskStatusById(taskStatusId);

        User user = userService.getUserByLogin(login);
        if (user.getRole().getAuthorities().stream().noneMatch(a -> a.getAuthority().equals("EDIT_STATUS"))){
            return ResponseEntity.badRequest().body(Map.of("message", "У вас нет доступа редактирования!"));
        }
        taskStatus.setName(newValue);
        taskStatusRepository.save(taskStatus);
        return ResponseEntity.ok(Map.of("message", "Статус Успешно отредактирован."));
    }
}
