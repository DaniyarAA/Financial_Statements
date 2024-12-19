//package kg.attractor.financial_statement.repository;
//
//import kg.attractor.financial_statement.entity.Company;
//import kg.attractor.financial_statement.entity.User;
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.data.jpa.repository.Modifying;
//import org.springframework.data.jpa.repository.Query;
//import org.springframework.data.repository.query.Param;
//import org.springframework.stereotype.Repository;
//import org.springframework.transaction.annotation.Transactional;
//
//import java.util.List;
//
//@Repository
//public interface CompanyRepository extends JpaRepository<Company, Long> {
//    @Transactional
//    @Modifying
//    @Query("""
//    UPDATE Company c
//    SET c.isDeleted = :isDeleted
//    WHERE c.id = :id
//    """)
//    void changeIsDeleted(@Param("id") Long id, @Param("isDeleted") Boolean isDeleted);
//
//    @Query("select c from Company c where c.isDeleted = :isDeleted")
//    List<Company> findByIsDeleted(@Param("isDeleted") Boolean isDeleted);
//
//    Boolean existsByName(String name);
//
//    Boolean existsByInn(String inn);
//
//    Boolean existsByDirectorInn(String directorInn);
//
//    Boolean existsByLogin(String login);
//
//    Boolean existsByKabinetSalyk(String kabinetSalyk);
//
//    List<Company> findByNameContainingIgnoreCase(String name);
//
//    List<Company> findAllByIsDeletedTrue();
//
//    @Query("SELECT c FROM Company c JOIN UserCompany uc ON c.id = uc.company.id WHERE uc.user = :user AND c.isDeleted = true")
//    List<Company> findDeletedCompaniesByUser(@Param("user") User user);
//}
