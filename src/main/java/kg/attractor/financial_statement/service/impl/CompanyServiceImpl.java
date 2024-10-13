package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.CompanyRepository;
import kg.attractor.financial_statement.repository.RoleRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.CompanyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
@Slf4j
@RequiredArgsConstructor
@Service
public class CompanyServiceImpl implements CompanyService {
    private final CompanyRepository companyRepository;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;


    @Override
    public void createCompany(Company company) {
        companyRepository.save(company);
    }



    @Override
    public Company findById(Long companyId) {
        return companyRepository.findById(companyId).orElseThrow(() -> new IllegalArgumentException("Invalid company ID"));
    }

    @Override
    public void editCompany(Company company) {
        companyRepository.updateCompanyDetails(
                company.getName(),
                company.getInn(),
                company.getDirectorInn(),
                company.getLogin(),
                company.getPassword(),
                company.getEcp(),
                company.getKabinetSalyk(),
                company.getKabinetSalykPassword(),
                company.getTaxMode(),
                company.getOpf(),
                company.getDistrictGns(),
                company.getSocfundNumber(),
                company.getRegistrationNumberMj(),
                company.getOkpo(),
                company.getDirector(),
                company.getKed(),
                company.getEmail(),
                company.getEmailPassword(),
                company.getPhone(),
                company.getEsf(),
                company.getEsfPassword(),
                company.getKkm(),
                company.getKkmPassword(),
                company.getFresh1c(),
                company.getFresh1cPassword(),
                company.getEttn(),
                company.getEttnPassword(),
                company.getId()
        );
    }


    @Override
    public boolean checkAuthorityForDelete(String name) {
        Role admin = roleRepository.findByRoleName("ADMIN");
        User user = userRepository.findByLogin(name);
        if (user == null) {
            return false;
        }
        return user.getRoles().contains(admin);
    }

    @Override
    public void deleteCompany(Long companyId) {
        companyRepository.deleteById(companyId);
    }

    @Override
    public List<Company> getAllCompanies() {
        return companyRepository.findAlWithoutPagination();
    }
}
