package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.DocumentTypeDto;
import kg.attractor.financial_statement.entity.DocumentType;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.enums.Document;
import kg.attractor.financial_statement.repository.DocumentTypeRepository;
import kg.attractor.financial_statement.service.DocumentTypeService;
import kg.attractor.financial_statement.service.TaskService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class DocumentTypeServiceImpl implements DocumentTypeService {
    private final DocumentTypeRepository documentTypeRepository;
    private final UserService userService;
    private  TaskService taskService;

    @Autowired
    @Lazy
    public void setTaskService(TaskService taskService) {
        this.taskService = taskService;
    }

    @Override
    public String getDocumentName(Long id) {
        DocumentType documentType = documentTypeRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("No document found for id " + id));
        return documentType.getName();
    }

    @Override
    public List<DocumentTypeDto> getAllDocumentTypes() {
        List<DocumentType> documentTypes = documentTypeRepository.findAll();
        return convertToDtoList(documentTypes);
    }

    @Override
    public DocumentType getDocumentTypeById(Long documentTypeId) {
        return documentTypeRepository.findById(documentTypeId)
                .orElseThrow(() -> new NoSuchElementException("Document type not found for id " + documentTypeId));
    }

    @Override
    public List<DocumentTypeDto> getFilteredDocumentTypes() {
        List<DocumentType> allDocumentTypes = documentTypeRepository.findAll();

        return allDocumentTypes.stream()
                .filter(DocumentType::isOptional)
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<DocumentType> getNonOptionalDocumentTypes() {
        return documentTypeRepository.findByIsOptionalFalse();
    }

    @Override
    public List<DocumentTypeDto> getDefaultDocumentTypes() {
        List<String> defaultDocumentTypeNames = Arrays.stream(Document.values())
                .map(Document::getTitle)
                .toList();
        List<DocumentType> allDocumentTypes = documentTypeRepository.findAll();
        List<DocumentType> defaultDocumentTypes = allDocumentTypes.stream()
                .filter(documentType -> defaultDocumentTypeNames.contains(documentType.getName()))
                .collect(Collectors.toList());
        return convertToDtoList(defaultDocumentTypes);
    }


    @Override
    public List<DocumentTypeDto> getChangeableDocumentTypes() {
        List<String> defaultDocumentTypeNames = Arrays.stream(Document.values())
                .map(Document::getTitle)
                .toList();
        List<DocumentType> allDocumentTypes = documentTypeRepository.findAll();
        List<DocumentType> changeableDocumentTypes = allDocumentTypes.stream()
                .filter(documentType -> !defaultDocumentTypeNames.contains(documentType.getName()))
                .collect(Collectors.toList());
        return convertToDtoList(changeableDocumentTypes);
    }

    @Override
    public ResponseEntity<Map<String, String>> edit(Map<String, String> data, String login) {
        String documentTypeIdStr = data.get("documentTypeId");
        String fieldToEdit = data.get("field");
        String newValue = data.get("value");

        if (documentTypeIdStr == null || fieldToEdit == null || newValue == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Неправильные вводные данные !"));
        }

        long documentTypeId;
        try {
            documentTypeId = Long.parseLong(documentTypeIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Нерабочая ID документа !"));
        }

        DocumentType documentType = getDocumentTypeById(documentTypeId);

        User user = userService.getUserByLogin(login);
        if (user.getRole().getAuthorities().stream().noneMatch(a -> a.getAuthority().equals("EDIT_DOCUMENT"))){
            return ResponseEntity.badRequest().body(Map.of("message", "У вас нет доступа редактирования!"));
        }
        documentType.setName(newValue);
        documentTypeRepository.save(documentType);
        return ResponseEntity.ok(Map.of("message", "Документ Успешно отредактирован."));
    }

    @Override
    public ResponseEntity<Map<String, String>> delete(Map<String, String> data, String login) {
        String documentTypeIdStr = data.get("id");
        Long documentId;
        try {
            documentId = Long.parseLong(documentTypeIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Нерабочая ID документа !"));
        }
        User user = userService.getUserByLogin(login);
        if (user.getRole().getAuthorities().stream().noneMatch(a -> a.getAuthority().equals("DELETE_DOCUMENT"))){
            return ResponseEntity.badRequest().body(Map.of("message", "У вас нет доступа удалению документа!"));
        }
        if (taskService.isTaskWithThisDocumentType(documentId)){
            return ResponseEntity.badRequest().body(Map.of("message", "Невозможно удалить так как есть таск с этим типом документа!"));
        }
        documentTypeRepository.deleteById(documentId);
        return ResponseEntity.ok(Map.of("message", "Документ Успешно Удален."));
    }

    @Override
    public ResponseEntity<Map<String, String>> create(DocumentTypeDto data, Principal principal) {
        User user = userService.getUserByLogin(principal.getName());
        if (user.getRole().getAuthorities().stream().noneMatch(a -> a.getAuthority().equals("CREATE_DOCUMENT"))){
            return ResponseEntity.badRequest().body(Map.of("message", "У вас нет доступа удалению документа!"));
        }
        if (documentTypeRepository.existsByName(data.getName())){
            return ResponseEntity.badRequest().body(Map.of("message", "Такой вид документа уже существует введите другой !"));
        }
        documentTypeRepository.save(convertToEntity(data));
        return ResponseEntity.ok(Map.of("message", "Документ Успешно создан."));
    }

    private DocumentType convertToEntity(DocumentTypeDto documentTypeDto) {
        return DocumentType.builder()
                .id(documentTypeDto.getId())
                .name(documentTypeDto.getName())
                .isOptional(documentTypeDto.isOptional())
                .build();
    }

    private DocumentTypeDto convertToDto(DocumentType documentType) {
        return DocumentTypeDto.builder()
                .id(documentType.getId())
                .name(documentType.getName())
                .isOptional(documentType.isOptional())
                .build();
    }

    private List<DocumentTypeDto> convertToDtoList(List<DocumentType> documentTypes) {
        return documentTypes.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
}
