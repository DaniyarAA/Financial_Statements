package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TagDto;
import kg.attractor.financial_statement.entity.Tag;
import kg.attractor.financial_statement.repository.TagRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.TagService;
import kg.attractor.financial_statement.service.TaskService;
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
    private final UserRepository userRepository;
    private final TaskService taskService;

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

    private TagDto convertToDto(Tag tag) {
        return TagDto.builder()
                .id(tag.getId())
                .tag(tag.getTag())
                .userId(tag.getUser() != null ? tag.getUser().getId() : null)
                .build();
    }

    public Tag convertToEntity(TagDto tagDto) {
        Tag tag = new Tag();
        tag.setTag(tagDto.getTag());
        tag.setUser(userRepository.findById(tagDto.getUserId())
                .orElseThrow(() -> new NoSuchElementException("User not found")));
        return tag;
    }
}