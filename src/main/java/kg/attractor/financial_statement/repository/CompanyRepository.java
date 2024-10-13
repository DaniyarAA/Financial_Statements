package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CompanyRepository extends JpaRepository<Company, Long> {
    @Query("select c from Company c")
    List<Company> findAlWithoutPagination();

    @Transactional
    @Modifying
    @Query("""
    UPDATE Company c
    SET c.name = :name,
        c.inn = :inn,
        c.directorInn = :directorInn,
        c.login = :login,
        c.password = :password,
        c.ecp = :ecp,
        c.kabinetSalyk = :kabinetSalyk,
        c.kabinetSalykPassword = :kabinetSalykPassword,
        c.taxMode = :taxMode,
        c.opf = :opf,
        c.districtGns = :districtGns,
        c.socfundNumber = :socfundNumber,
        c.registrationNumberMj = :registrationNumberMj,
        c.okpo = :okpo,
        c.director = :director,
        c.ked = :ked,
        c.email = :email,
        c.emailPassword = :emailPassword,
        c.phone = :phone,
        c.esf = :esf,
        c.esfPassword = :esfPassword,
        c.kkm = :kkm,
        c.kkmPassword = :kkmPassword,
        c.fresh1c = :fresh1c,
        c.fresh1cPassword = :fresh1cPassword,
        c.ettn = :ettn,
        c.ettnPassword = :ettnPassword
    WHERE c.id = :companyId
    """)
    void updateCompanyDetails(
            @Param("name") String name,
            @Param("inn") String inn,
            @Param("directorInn") String directorInn,
            @Param("login") String login,
            @Param("password") String password,
            @Param("ecp") String ecp,
            @Param("kabinetSalyk") String kabinetSalyk,
            @Param("kabinetSalykPassword") String kabinetSalykPassword,
            @Param("taxMode") String taxMode,
            @Param("opf") String opf,
            @Param("districtGns") String districtGns,
            @Param("socfundNumber") String socfundNumber,
            @Param("registrationNumberMj") String registrationNumberMj,
            @Param("okpo") String okpo,
            @Param("director") String director,
            @Param("ked") String ked,
            @Param("email") String email,
            @Param("emailPassword") String emailPassword,
            @Param("phone") String phone,
            @Param("esf") String esf,
            @Param("esfPassword") String esfPassword,
            @Param("kkm") String kkm,
            @Param("kkmPassword") String kkmPassword,
            @Param("fresh1c") String fresh1c,
            @Param("fresh1cPassword") String fresh1cPassword,
            @Param("ettn") String ettn,
            @Param("ettnPassword") String ettnPassword,
            @Param("companyId") Long companyId
    );
}
