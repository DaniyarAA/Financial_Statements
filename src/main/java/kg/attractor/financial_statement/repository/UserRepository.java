package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByLogin(String login);
}
