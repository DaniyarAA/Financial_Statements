package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByUserCompanyIdIn(List<Long> userCompanyIds);

    @Query("SELECT t FROM Task t WHERE t.userCompany.id IN :userCompanyIds " +
            "AND YEAR(t.startDateTime) = :year " +
            "AND MONTH(t.startDateTime) = :month")
    List<Task> findByUserCompanyIdInAndStartDatetimeYearAndMonth(
            @Param("userCompanyIds") List<Long> userCompanyIds,
            @Param("year") int year,
            @Param("month") int month
    );
}
