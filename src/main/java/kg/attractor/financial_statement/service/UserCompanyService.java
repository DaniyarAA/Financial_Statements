package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;

import java.util.List;

public interface UserCompanyService {
    UserCompany findUserCompanyByTaskCreateDto(TaskCreateDto taskCreateDto);

    UserCompany findUserCompanyByTaskCreateDtoAndLogin(TaskCreateDto taskCreateDto, String login);

    CompanyDto convertToCompanyToCompanyDto(Company company);

    List<UserCompany> findUserCompanyByUser(User user);
    List<Long> findUserCompanyIdsForUser(User user);
    void save(UserCompany userCompany);
}
