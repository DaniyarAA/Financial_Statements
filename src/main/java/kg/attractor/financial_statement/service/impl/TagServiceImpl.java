package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TagDto;
import kg.attractor.financial_statement.entity.Tag;
import kg.attractor.financial_statement.repository.TagRepository;
import kg.attractor.financial_statement.service.TagService;
import kg.attractor.financial_statement.service.TaskService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TagServiceImpl implements TagService {
    private final TagRepository tagRepository;
    private final TaskService taskService;
    private final UserService userService;

    @Override
    public TagDto getTagById(Long id) {
        return tagRepository.findById(id)
                .map(this::convertToDto)
                .orElseThrow(() -> new NoSuchElementException("Tag with ID " + id + " not found."));
    }

    @Override
    public List<TagDto> getAllTags() {
        return tagRepository.findAll()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public void createTag(TagDto tagDto) {
        Tag tag = convertToEntity(tagDto);
        tagRepository.save(tag);

        if (tagDto.getTaskId() != null) {
            taskService.updateTaskTag(tagDto.getTaskId(), tag);
        }
    }

    @Override
    public long countByUserId(Long userId) {
        return tagRepository.countByUserId(userId);
    }

    @Override
    public List<TagDto> getTagsByUserId(Long userId) {
        return tagRepository.findByUserId(userId)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public TagDto getTagForTask(Long taskId) {
        return tagRepository.findByTasks_Id(taskId)
                .map(this::convertToDto)
                .orElse(null);
    }

    @Override
    public void updateTagForTask(Long taskId, Long tagId) {
        Tag tag = tagRepository.findById(tagId)
                .orElseThrow(() -> new NoSuchElementException("Tag not found"));

        taskService.updateTaskTag(taskId, tag);
    }

    //todo тег применяется только к первой задаче, скрытый тег появляется только после обновления страницы, добавить проверку на то что тег не должен быть меньше трех символов(а именно лучше сделать проверку на любое количество символов, но если привышает больше трех то уже укороченный вариант, сделать ограничение на больше 10 тегов и выборка с админом

    private TagDto convertToDto(Tag tag) {
        return TagDto.builder()
                .id(tag.getId())
                .tag(tag.getTag() !=null ? tag.getTag() : null)
                .userId(tag.getUser() != null ? tag.getUser().getId() : null)
                .build();
    }

    public Tag convertToEntity(TagDto tagDto) {
        Tag tag = new Tag();
        tag.setTag(tagDto.getTag());
        tag.setUser(userService.getUserById(tagDto.getUserId()));
        return tag;
    }
}