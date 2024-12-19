//package kg.attractor.financial_statement.service.impl;
//
//import kg.attractor.financial_statement.dto.DocumentTypeDto;
//import kg.attractor.financial_statement.entity.DocumentType;
//import kg.attractor.financial_statement.repository.DocumentTypeRepository;
//import kg.attractor.financial_statement.service.DocumentTypeService;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//import java.util.NoSuchElementException;
//import java.util.stream.Collectors;
//
//@Service
//@Slf4j
//@RequiredArgsConstructor
//public class DocumentTypeServiceImpl implements DocumentTypeService {
//    private final DocumentTypeRepository documentTypeRepository;
//
//    @Override
//    public String getDocumentName(Long id) {
//        DocumentType documentType = documentTypeRepository.findById(id)
//                .orElseThrow(() -> new NoSuchElementException("No document found for id " + id));
//        return documentType.getName();
//    }
//
//    @Override
//    public List<DocumentTypeDto> getAllDocumentTypes() {
//        List<DocumentType> documentTypes = documentTypeRepository.findAll();
//        return convertToDtoList(documentTypes);
//    }
//
//    @Override
//    public DocumentType getDocumentTypeById(Long documentTypeId) {
//        return documentTypeRepository.findById(documentTypeId)
//                .orElseThrow(() -> new NoSuchElementException("Document type not found for id " + documentTypeId));
//    }
//
//    @Override
//    public List<DocumentTypeDto> getFilteredDocumentTypes() {
//        List<DocumentType> allDocumentTypes = documentTypeRepository.findAll();
//
//        return allDocumentTypes.stream()
//                .filter(DocumentType::isOptional)
//                .map(this::convertToDto)
//                .collect(Collectors.toList());
//    }
//
//    @Override
//    public List<DocumentType> getNonOptionalDocumentTypes() {
//        return documentTypeRepository.findByIsOptionalFalse();
//    }
//
//    private DocumentTypeDto convertToDto(DocumentType documentType) {
//        return DocumentTypeDto.builder()
//                .id(documentType.getId())
//                .name(documentType.getName())
//                .isOptional(documentType.isOptional())
//                .build();
//    }
//
//    private List<DocumentTypeDto> convertToDtoList(List<DocumentType> documentTypes) {
//        return documentTypes.stream()
//                .map(this::convertToDto)
//                .collect(Collectors.toList());
//    }
//}
