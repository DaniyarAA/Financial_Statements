package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.UserCompany;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserCompanyRepository extends JpaRepository<UserCompany, Long> {
}
