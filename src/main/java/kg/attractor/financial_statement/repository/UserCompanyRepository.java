package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.UserCompany;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserCompanyRepository extends JpaRepository<UserCompany, Long> {
//    boolean existsByUserAndCompany(String userLogin, Long companyId);
    Optional<UserCompany> findByUserLoginAndCompanyId(String userLogin, Long companyId);

}
