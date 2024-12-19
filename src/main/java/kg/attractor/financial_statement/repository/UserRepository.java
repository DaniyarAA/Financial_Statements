package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByLogin(String login);
    Optional<User> findByEmail(String email);

    boolean existsByLogin(String admin);

    List<User> findAllByEnabledIsFalse();
}
