package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserCompanyRepository extends JpaRepository<UserCompany, Long> {
    Optional<UserCompany> findByUserLoginAndCompanyId(String userLogin, Long companyId);
    boolean existsByUserAndCompany(User user, Company company);

    Optional<UserCompany> findByUserIdAndCompanyId(Long appointToUserId, Long companyId);

    List<UserCompany> findByUserIdAndCompanyIdIn(Long userId, List<Long> companyIds);

    List<UserCompany> findByUser(User user);
    Optional<UserCompany> findByCompany(Company company);
}
