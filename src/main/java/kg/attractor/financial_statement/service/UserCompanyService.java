package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;

import java.util.List;

public interface UserCompanyService {
    UserCompany findUserCompanyByTaskCreateDto(TaskCreateDto taskCreateDto);

    UserCompany findUserCompanyByTaskCreateDtoAndLogin(TaskCreateDto taskCreateDto, String login);

    void updateUserCompanies(User user, List<Company> newCompanies);

    List<UserCompany> findByUser(User user);
}
