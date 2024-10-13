package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.entity.Company;

import java.util.List;

public interface CompanyService {
    void createCompany(Company company);



    Company findById(Long companyId);

    void editCompany(Company company);

    boolean checkAuthorityForDelete(String name);

    void deleteCompany(Long companyId);

    List<Company> getAllCompanies();
}
