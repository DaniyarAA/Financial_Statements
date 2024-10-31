package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.DocumentTypeDto;
import kg.attractor.financial_statement.entity.DocumentType;

import java.util.List;

public interface DocumentTypeService {
    String getDocumentName(Long id);

    List<DocumentTypeDto> getAllDocumentTypes();

    DocumentType getDocumentTypeById(Long documentTypeId);

    List<DocumentTypeDto> getFilteredDocumentTypes();
}
