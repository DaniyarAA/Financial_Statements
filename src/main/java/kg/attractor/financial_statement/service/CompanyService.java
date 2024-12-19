package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.dto.CompanyForTaskDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;

import java.util.List;
import java.util.Map;

public interface CompanyService {
    ResponseEntity<Map<String, String>> createCompany(CompanyDto company, String login, BindingResult bindingResult);

    void assignUserToCompany(Company company, String login);

    CompanyDto findById(Long companyId);

    void editCompany(CompanyDto company);

    void deleteCompany(Long companyId);

    List<CompanyDto> getAllCompanies();

    List<Company> findAllById(List<Long> companyIds);

    ResponseEntity<Map<String, String>> editByOne(Map<String, String> data);

    CompanyDto convertToDto(Company company);

    Company getCompanyById(Long companyId);

    CompanyForTaskDto getCompanyForTaskDto(Long id);

    Company convertToEntity(CompanyDto companyDto);

    List<CompanyDto> getAllCompaniesBySort(String sort);

    void returnCompany(Long companyId);

    boolean existsByCompanyName(String companyName);

    List<CompanyDto> findByName(String search);

    boolean existsByCompanyInn(String companyInn);

    boolean existsByCompanyDirectorInn(String companyDirectorInn);

    boolean existsByCompanyLogin(String companyLogin);

    boolean existsByCompanySalykLogin(String salykLogin);

    List<CompanyForTaskDto> getAllCompaniesForUser(User user);

    void addCompany(CompanyDto companyDto , String login);

    List<Company> findAll();

    List<CompanyDto> getDeletedCompaniesByUser(Long userId);

    List<CompanyDto> getAllDeletedCompanies();

    void resumeCompany(Long companyId);
}
