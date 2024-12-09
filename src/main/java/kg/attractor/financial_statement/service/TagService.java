package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TagDto;

import java.util.List;

public interface TagService {
    TagDto getTagById(Long id);

    List<TagDto> getAllTags();

    void createTag(TagDto tagDto);

    long countByUserId(Long userId);

    boolean isTagUnique(Long userId, String tagName);

    List<TagDto> getTagsByUserId(Long userId);

    TagDto getTagForTask(Long taskId);

    void updateTagForTask(Long taskId, Long tagId);
}
