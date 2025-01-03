package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Authority;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AuthorityRepository extends JpaRepository<Authority, Long> {
}
