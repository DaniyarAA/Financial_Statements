package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskRepository extends JpaRepository<Task, Long> {
}
