package kg.attractor.financial_statement.service.impl;

import jakarta.transaction.Transactional;
import kg.attractor.financial_statement.dto.TaskCreateDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.UserCompanyRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.UserCompanyService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserCompanyServiceImpl implements UserCompanyService {
    private final UserCompanyRepository userCompanyRepository;
    private final UserService userService;
    private final CompanyService companyService;
    @Override
    public UserCompany findUserCompanyByTaskCreateDto(TaskCreateDto taskCreateDto) {
        Long userId = taskCreateDto.getAppointToUserId();
        Long companyId = taskCreateDto.getCompanyId();

        User user = userService.getUserById(userId);
        Company company = companyService.getCompanyById(companyId);
        boolean isExists = userCompanyRepository.existsByUserAndCompany(user, company);

        if (!isExists) {
            UserCompany userCompany = new UserCompany();
            userCompany.setUser(userService.getUserById(userId));
            userCompany.setCompany(companyService.getCompanyById(companyId));

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

        User user = userService.getUserByLogin(login);
        Company company = companyService.getCompanyById(companyId);
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
    @Transactional
    public void updateUserCompanies(User user, List<Company> newCompanies){
        List<UserCompany> existingUserCompanies = findByUser(user);
        List<Company> existingCompanies = existingUserCompanies.stream()
                .map(UserCompany::getCompany)
                .toList();
        for (Company company : newCompanies) {
            if (!existingCompanies.contains(company)) {
                UserCompany userCompany = new UserCompany();
                userCompany.setUser(user);
                userCompany.setCompany(company);
                userCompanyRepository.save(userCompany);
            }
        }
        for (UserCompany userCompany : existingUserCompanies) {
            if (!newCompanies.contains(userCompany.getCompany())) {
                userCompanyRepository.delete(userCompany);
            }
        }
    }


    @Override
    public List<UserCompany> findByUser(User user){
        return userCompanyRepository.findByUser(user);
    }
}
