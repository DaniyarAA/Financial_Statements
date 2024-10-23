package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.TaskStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskStatusRepository extends JpaRepository<TaskStatus, Long> {
}
