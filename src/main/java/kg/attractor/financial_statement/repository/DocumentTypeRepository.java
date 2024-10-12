package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.DocumentType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DocumentTypeRepository extends JpaRepository<DocumentType, Long> {
}
