package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.CompanyDto;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Map;

public interface CompanyService {
    void createCompany(CompanyDto company,String login);

    CompanyDto findById(Long companyId);

    void editCompany(CompanyDto company);

    void deleteCompany(Long companyId);

    List<CompanyDto> getAllCompanies();

    ResponseEntity<Map<String, String>> editByOne(Map<String, String> data);
}
