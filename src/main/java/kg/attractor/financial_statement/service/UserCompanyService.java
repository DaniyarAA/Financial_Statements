package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.entity.UserCompany;

public interface UserCompanyService {
    UserCompany findUserCompanyByTaskCreateDto(TaskCreateDto taskCreateDto);

    UserCompany findUserCompanyByTaskCreateDtoAndLogin(TaskCreateDto taskCreateDto, String login);
}
