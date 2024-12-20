package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.*;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
//    List<Task> findByUserCompanyIdIn(List<Long> userCompanyIds);
//
//    @Query("SELECT t FROM Task t WHERE t.userCompany.id IN :userCompanyIds " +
//            "AND YEAR(t.startDate) = :year " +
//            "AND MONTH(t.startDate) = :month")
//    List<Task> findByUserCompanyIdInAndStartDatetimeYearAndMonth(
//            @Param("userCompanyIds") List<Long> userCompanyIds,
//            @Param("year") int year,
//            @Param("month") int month
//    );
//
//    List<Task> findByUserCompanyIdInOrderByEndDateAsc(List<Long> userCompanyIds);
//
//    List<Task> findByUserCompanyIdInOrderByEndDateDesc(List<Long> userCompanyIds);
//
//    List<Task> findByUserCompanyIdInOrderByIdAsc(List<Long> userCompanyIds);
//
//    List<Task> findByUserCompanyIdInOrderByIdDesc(List<Long> userCompanyIds);

    List<Task> findAllByTaskStatus(TaskStatus taskStatus);

//    List<Task> findAllByUserCompany_UserAndTaskStatus(User user, TaskStatus taskStatus);

//    List<Task> findByUserCompany_Company_IdAndEndDateBetween(Long companyId, LocalDate start, LocalDate end);
//
//    boolean existsByUserCompanyAndStartDateAndEndDateAndDocumentType(
//            UserCompany userCompany, LocalDate startDate, LocalDate endDate, DocumentType documentType);
//List<Task> findByCompanyInAndStartDateYearAndStartDateMonth(
//        List<Company> companies, int year, int month);
    @Query("SELECT t FROM Task t WHERE t.company IN :companies AND YEAR(t.startDate) = :year AND MONTH(t.startDate) = :month")
    List<Task> findByCompanyInAndStartDateYearAndStartDateMonth(@Param("companies") List<Company> companies, @Param("year") int year, @Param("month") int month);
  List<Task> findAllByCompany(Company company);
  List<Task> findByCompanyId(Long company_id);
//    List<Task> findAllByCompanyIds(Set<Long> companyIds);
    List<Task> findByCompanyIdAndEndDateBetween(Long companyId, LocalDate startDate, LocalDate endDate);
    List<Task> findAllByUsersAndTaskStatus(List<User> users, TaskStatus taskStatus);


}
