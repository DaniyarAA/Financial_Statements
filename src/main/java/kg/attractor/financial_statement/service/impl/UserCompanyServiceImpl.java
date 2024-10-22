package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.UserCompanyRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.UserCompanyService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserCompanyServiceImpl implements UserCompanyService {
    private final UserCompanyRepository userCompanyRepository;
    private final UserService userService;
    private final CompanyService companyService;
    @Override
    public UserCompany findUserCompanyByTaskCreateDto(TaskCreateDto taskCreateDto) {
        String userLogin = taskCreateDto.getUserLogin();
        Long companyId = taskCreateDto.getCompanyId();

//        boolean isExists = userCompanyRepository.existsByUserAndCompany(userLogin, companyId);
//
//        if (!isExists) {
//            UserCompany userCompany = new UserCompany();
//            userCompany.setUser(userService.getUserModelByLogin(userLogin));
//            userCompany.setCompany(companyService.getCompanyById(companyId));
//
//            userCompanyRepository.save(userCompany);
//        }

        return null;
    }
}
