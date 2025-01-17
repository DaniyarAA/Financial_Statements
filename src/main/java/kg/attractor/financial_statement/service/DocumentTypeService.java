package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.DocumentTypeDto;
import kg.attractor.financial_statement.entity.DocumentType;
import org.springframework.http.ResponseEntity;

import java.security.Principal;
import java.util.List;
import java.util.Map;

public interface DocumentTypeService {
    String getDocumentName(Long id);

    List<DocumentTypeDto> getAllDocumentTypes();

    DocumentType getDocumentTypeById(Long documentTypeId);

    List<DocumentTypeDto> getFilteredDocumentTypes();

    List<DocumentType> getNonOptionalDocumentTypes();

    List<DocumentTypeDto> getDefaultDocumentTypes();

    List<DocumentTypeDto> getChangeableDocumentTypes();

    ResponseEntity<Map<String, String>> edit(Map<String, String> data, String login);

    ResponseEntity<Map<String, String>> delete(Map<String, String> data, String name);

    ResponseEntity<Map<String, String>> create(DocumentTypeDto data, Principal principal,int idBool);
}
