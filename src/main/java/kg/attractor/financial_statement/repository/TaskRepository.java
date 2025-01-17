package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.dto.TaskDto;
import kg.attractor.financial_statement.entity.*;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

import java.util.List;


@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findAllByTaskStatus(TaskStatus taskStatus);
    @Query("SELECT t FROM Task t WHERE t.company IN :companies AND YEAR(t.endDate) = :year AND MONTH(t.endDate) = :month")
    List<Task> findByCompanyInAndEndDateYearAndEndDateMonth(@Param("companies") List<Company> companies, @Param("year") int year, @Param("month") int month);
    List<Task> findByCompanyId(Long company_id);
    List<Task> findByCompanyIdAndEndDateBetween(Long companyId, LocalDate startDate, LocalDate endDate);
    List<Task> findAllByUsersAndTaskStatus(List<User> users, TaskStatus taskStatus);
    List<Task> findAllByUsers_IdAndCompany_Id(Long userId, Long companyId);
}
