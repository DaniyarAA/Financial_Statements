package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.dto.CompanyForTaskDto;
import kg.attractor.financial_statement.entity.Company;

import java.util.List;

public interface CompanyService {
    void createCompany(CompanyDto company);

    CompanyDto findById(Long companyId);

    void editCompany(CompanyDto company);

    void deleteCompany(Long companyId);

    List<CompanyDto> getAllCompanies();

    Company getCompanyById(Long companyId);

    CompanyForTaskDto getCompanyForTaskDto(Long id);
}
