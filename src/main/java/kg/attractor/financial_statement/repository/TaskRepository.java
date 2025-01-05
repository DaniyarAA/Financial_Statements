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
    @Query("SELECT t FROM Task t WHERE t.company IN :companies AND YEAR(t.startDate) = :year AND MONTH(t.startDate) = :month")
    List<Task> findByCompanyInAndStartDateYearAndStartDateMonth(@Param("companies") List<Company> companies, @Param("year") int year, @Param("month") int month);
    List<Task> findByCompanyId(Long company_id);
    List<Task> findByCompanyId(Long company_id, Sort sort);
    List<Task> findByUsersIdOrderByIdAsc(Long userId);
    List<Task> findByUsersIdOrderByIdDesc(Long userId);
    List<Task> findByUsersIdOrderByEndDateAsc(Long userId);
    List<Task> findByUsersIdOrderByEndDateDesc(Long userId);
    List<Task> findByUsersIdOrderByPriorityIdAsc(Long userId);
    List<Task> findByUsersIdOrderByPriorityIdDesc(Long userId);
    List<Task> findByCompanyIdAndEndDateBetween(Long companyId, LocalDate startDate, LocalDate endDate);
    List<Task> findAllByUsersAndTaskStatus(List<User> users, TaskStatus taskStatus);
    List<Task> findAllByCompany_Id(Long companyId);

    List<Task> findAllByUsers_IdAndCompany_Id(Long userId, Long companyId);
}
