//package kg.attractor.financial_statement.service.impl;
//
//import kg.attractor.financial_statement.dto.CompanyDto;
//import kg.attractor.financial_statement.dto.TaskCreateDto;
//import kg.attractor.financial_statement.entity.Company;
//import kg.attractor.financial_statement.entity.User;
//import kg.attractor.financial_statement.repository.UserCompanyRepository;
//import kg.attractor.financial_statement.service.CompanyService;
//import kg.attractor.financial_statement.service.UserCompanyService;
//import kg.attractor.financial_statement.service.UserService;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.annotation.Lazy;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//import java.util.NoSuchElementException;
//import java.util.Optional;
//import java.util.stream.Collectors;
//
//@Service
//@RequiredArgsConstructor
//@Slf4j
//public class UserCompanyServiceImpl implements UserCompanyService {
//    private final UserCompanyRepository userCompanyRepository;
//    private final UserService userService;
//    private CompanyService companyService;
//
//    @Lazy
//    @Autowired
//    private void setCompanyService(CompanyService companyService) {
//        this.companyService = companyService;
//    }
//
//    @Override
//    public UserCompany findUserCompanyByTaskCreateDto(TaskCreateDto taskCreateDto) {
//        Long userId = taskCreateDto.getAppointToUserId();
//        Long companyId = taskCreateDto.getCompanyId();
//
//        User user = userService.getUserById(userId);
//        Company company = companyService.getCompanyById(companyId);
//        boolean isExists = userCompanyRepository.existsByUserAndCompany(user, company);
//
//        if (!isExists) {
//            UserCompany userCompany = new UserCompany();
//            userCompany.setUser(userService.getUserById(userId));
//            userCompany.setCompany(companyService.getCompanyById(companyId));
//
//            UserCompany newUserCompany = userCompanyRepository.save(userCompany);
//            return newUserCompany;
//        }   else {
//            return userCompanyRepository.findByUserIdAndCompanyId(taskCreateDto.getAppointToUserId(), taskCreateDto.getCompanyId())
//                    .orElseThrow(() -> new NoSuchElementException("User company not found with companyId: " + taskCreateDto.getCompanyId() + " and userId: " + taskCreateDto.getAppointToUserId()));
//
//        }
//    }
//
//    @Override
//    public UserCompany findUserCompanyByTaskCreateDtoAndLogin(TaskCreateDto taskCreateDto, String login) {
//        Long companyId = taskCreateDto.getCompanyId();
//
//        User user = userService.getUserByLogin(login);
//        Company company = companyService.getCompanyById(companyId);
//        boolean isExists = userCompanyRepository.existsByUserAndCompany(user, company);
//
//        if (!isExists) {
//            UserCompany userCompany = new UserCompany();
//            userCompany.setUser(user);
//            userCompany.setCompany(company);
//
//            UserCompany newUserCompany = userCompanyRepository.save(userCompany);
//            return newUserCompany;
//        } else {
//            return userCompanyRepository.findByUserIdAndCompanyId(taskCreateDto.getAppointToUserId(), taskCreateDto.getCompanyId())
//                    .orElseThrow(() -> new NoSuchElementException("User company not found with companyId: " + taskCreateDto.getCompanyId() + " and userId: " + taskCreateDto.getAppointToUserId()));
//        }
//    }
//
//    @Override
//    public void updateUserCompanies(User user, List<Company> newCompanies){
//        List<UserCompany> existingUserCompanies = findByUser(user);
//        for (Company company : newCompanies) {
//            Optional<UserCompany> existingUserCompany = userCompanyRepository.findByCompanyAndUser(company, user);
//
//            if (existingUserCompany.isPresent()) {
//                continue;
//            }
//            List<UserCompany> userCompaniesWithNullUser = userCompanyRepository.findByCompanyAndUserIsNull(company);
//
//            if (!userCompaniesWithNullUser.isEmpty()) {
//                for (UserCompany userCompany : userCompaniesWithNullUser) {
//                    userCompany.setUser(user);
//                    userCompanyRepository.save(userCompany);
//                }
//            } else {
//                UserCompany newUserCompany = new UserCompany();
//                newUserCompany.setCompany(company);
//                newUserCompany.setUser(user);
//                userCompanyRepository.save(newUserCompany);
//            }
//        }
//        for (UserCompany userCompany : existingUserCompanies) {
//            if (!newCompanies.contains(userCompany.getCompany())) {
//                userCompany.setUser(null);
//                userCompanyRepository.save(userCompany);
//            }
//        }
//    }
//
//    @Override
//    public void updateUserCompaniesOnUserDeletion(Long userId){
//        List<UserCompany> userCompanies = userCompanyRepository.findAllByUserId(userId);
//        if(!userCompanies.isEmpty()){
//            for (UserCompany userCompany : userCompanies) {
//                userCompany.setUser(null);
//                userCompanyRepository.save(userCompany);
//            }
//        }
//    }
//
//    @Override
//    public List<UserCompany> findByUser(User user){
//        return userCompanyRepository.findByUser(user);
//    }
//
//    @Override
//    public List<UserCompany> findByUserIdAndCompanyIdIn(Long userId, List<Long> collect) {
//        return userCompanyRepository.findByUserIdAndCompanyIdIn(userId, collect);
//    }
//
//    @Override
//    public Optional<UserCompany> findByCompany(Company company) {
//        return userCompanyRepository.findByCompany(company);
//    }
//
//    @Override
//    public CompanyDto convertToCompanyToCompanyDto(Company company) {
//        return companyService.convertToDto(company);
//    }
//
//    @Override
//    public List<UserCompany> findUserCompanyByUser(User user) {
//        return userCompanyRepository.findByUser(user);
//    }
//
//    @Override
//    public void save(UserCompany userCompany) {
//        userCompanyRepository.save(userCompany);
//    }
//
//    @Override
//    public List<Long> findUserCompanyIdsForUser(User user) {
//        List<UserCompany> userCompanies = findUserCompanyByUser(user);
//
//        return userCompanies.stream()
//                .map(UserCompany::getId)
//                .collect(Collectors.toList());
//    }
//
//    @Override
//    public List<UserCompany> findByCompanyAndIsAutomatic(Company company, boolean isAutomatic) {
//        return userCompanyRepository.findByCompanyAndIsAutomatic(company, isAutomatic);
//    }
//
//    @Override
//    public List<UserCompany> findAll() {
//        return userCompanyRepository.findAll();
//    }
//}
