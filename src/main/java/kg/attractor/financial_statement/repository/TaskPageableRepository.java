package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Task;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskPageableRepository extends PagingAndSortingRepository<Task, Long> {
    Page<Task> findByDocumentTypeIdAndTaskStatusId(Long documentTypeId, Long statusId, Pageable pageable);

    Page<Task> findByDocumentTypeId(Long documentTypeId, Pageable pageable);

    Page<Task> findByTaskStatusId(Long statusId, Pageable pageable);
}
