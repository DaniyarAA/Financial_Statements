package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Tag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TagRepository extends JpaRepository<Tag, Long> {
    List<Tag> findByUserId(Long userId);

    Optional<Tag> findByTasks_Id(Long taskId);
}
