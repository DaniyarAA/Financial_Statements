package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CompanyRepository extends JpaRepository<Company, Long> {
}
