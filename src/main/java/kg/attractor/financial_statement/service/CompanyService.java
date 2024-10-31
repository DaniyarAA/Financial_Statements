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

    CompanyDto findById(Long companyId);

    void editCompany(CompanyDto company);

    void deleteCompany(Long companyId);

    List<CompanyDto> getAllCompanies();

    ResponseEntity<Map<String, String>> editByOne(Map<String, String> data);

    CompanyDto convertToDto(Company company);

    Company getCompanyById(Long companyId);

    CompanyForTaskDto getCompanyForTaskDto(Long id);

    List<CompanyForTaskDto> getAllCompaniesForUser(User user);
}
