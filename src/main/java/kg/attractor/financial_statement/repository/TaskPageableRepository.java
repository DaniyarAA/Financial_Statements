package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Task;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskPageableRepository extends PagingAndSortingRepository<Task, Long> {
}
