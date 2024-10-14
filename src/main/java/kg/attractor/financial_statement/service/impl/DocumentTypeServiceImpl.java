package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.entity.DocumentType;
import kg.attractor.financial_statement.repository.DocumentTypeRepository;
import kg.attractor.financial_statement.service.DocumentTypeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@Slf4j
@RequiredArgsConstructor
public class DocumentTypeServiceImpl implements DocumentTypeService {
    private final DocumentTypeRepository documentTypeRepository;

    @Override
    public String getDocumentName(Long id) {
        DocumentType documentType = documentTypeRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("No document found for id " + id));
        return documentType.getName();
    }
}
