package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.UserCompanyRepository;
import kg.attractor.financial_statement.service.UserCompanyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserCompanyServiceImpl implements UserCompanyService {
    private final UserCompanyRepository userCompanyRepository;
    private final UserPrivateService userPrivateService;
    private final CompanyPrivateService companyPrivateService;

    @Override
    public UserCompany findUserCompanyByTaskCreateDto(TaskCreateDto taskCreateDto) {
        Long userId = taskCreateDto.getAppointToUserId();
        Long companyId = taskCreateDto.getCompanyId();

        User user = userPrivateService.getUserById(userId);
        Company company = companyPrivateService.getCompanyById(companyId);
        boolean isExists = userCompanyRepository.existsByUserAndCompany(user, company);

        if (!isExists) {
            UserCompany userCompany = new UserCompany();
            userCompany.setUser(userPrivateService.getUserById(userId));
            userCompany.setCompany(companyPrivateService.getCompanyById(companyId));

            UserCompany newUserCompany = userCompanyRepository.save(userCompany);
            return newUserCompany;
        }   else {
            return userCompanyRepository.findByUserIdAndCompanyId(taskCreateDto.getAppointToUserId(), taskCreateDto.getCompanyId())
                    .orElseThrow(() -> new NoSuchElementException("User company not found with companyId: " + taskCreateDto.getCompanyId() + " and userId: " + taskCreateDto.getAppointToUserId()));

        }

    }

    @Override
    public UserCompany findUserCompanyByTaskCreateDtoAndLogin(TaskCreateDto taskCreateDto, String login) {
        Long companyId = taskCreateDto.getCompanyId();

        User user = userPrivateService.getUserByLogin(login);
        Company company = companyPrivateService.getCompanyById(companyId);
        boolean isExists = userCompanyRepository.existsByUserAndCompany(user, company);

        if (!isExists) {
            UserCompany userCompany = new UserCompany();
            userCompany.setUser(user);
            userCompany.setCompany(company);

            UserCompany newUserCompany = userCompanyRepository.save(userCompany);
            return newUserCompany;
        } else {
            return userCompanyRepository.findByUserIdAndCompanyId(taskCreateDto.getAppointToUserId(), taskCreateDto.getCompanyId())
                    .orElseThrow(() -> new NoSuchElementException("User company not found with companyId: " + taskCreateDto.getCompanyId() + " and userId: " + taskCreateDto.getAppointToUserId()));
        }
    }

    @Override
    public CompanyDto convertToCompanyToCompanyDto(Company company) {
        return companyPrivateService.convertToDto(company);
    }

    @Override
    public List<UserCompany> findUserCompanyByUser(User user) {
        return userCompanyRepository.findByUser(user);
    }

    @Override
    public void save(UserCompany userCompany) {
        userCompanyRepository.save(userCompany);
    }

    @Override
    public List<Long> findUserCompanyIdsForUser(User user) {
        List<UserCompany> userCompanies = findUserCompanyByUser(user);

        return userCompanies.stream()
                .map(UserCompany::getId)
                .collect(Collectors.toList());
    }
}
