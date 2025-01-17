package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.dto.CompanyForTaskCreateDto;
import kg.attractor.financial_statement.dto.CompanyForTaskDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;

import java.util.List;
import java.util.Map;

public interface CompanyService {
    ResponseEntity<Map<String, String>> createCompany(CompanyDto company, String login, BindingResult bindingResult);

    void assignUserToCompany(Company company, String login);

    CompanyDto findById(Long companyId);

    void editCompany(CompanyDto company);

    void deleteCompany(Long companyId , String login);

    List<CompanyDto> getAllCompanies();

    List<Company> findAllById(List<Long> companyIds);

    ResponseEntity<Map<String, String>> editByOne(Map<String, String> data ,String login);

    CompanyDto convertToDto(Company company);

    Company getCompanyById(Long companyId);

    CompanyForTaskDto getCompanyForTaskDto(Long id);

    Company convertToEntity(CompanyDto companyDto);

    List<CompanyDto> getAllCompaniesBySort(String sort,String login);

    void returnCompany(Long companyId,String login);

    boolean existsByCompanyName(String companyName);

    List<CompanyDto> findByName(String search);

    boolean existsByCompanyInn(String companyInn);

    boolean existsByCompanyDirectorInn(String companyDirectorInn);

    boolean existsByCompanyLogin(String companyLogin);

    boolean existsByCompanySalykLogin(String salykLogin);

    List<CompanyForTaskDto> getAllCompaniesForUser(Long userId);

    void addCompany(CompanyDto companyDto , String login);

    List<Company> findAll();

    Page<CompanyDto> getDeletedCompaniesByUser(Long userId, Pageable pageable);

    Page<CompanyDto> getAllDeletedCompanies(Pageable pageable);

    void resumeCompany(Long companyId);

    List<CompanyForTaskCreateDto> getAllCompaniesForCreateTask();

    CompanyDto findByIdInUserList(List<CompanyDto> allCompanies, Long companyId);

    String getCompanyNameById(Long companyId);
}
