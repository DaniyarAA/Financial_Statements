package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.repository.CompanyRepository;
import kg.attractor.financial_statement.service.CompanyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class CompanyServiceImpl implements CompanyService {
    private final CompanyRepository companyRepository;

    @Override
    public void createCompany(CompanyDto companyDto) {
        Company company = convertToEntity(companyDto);
        companyRepository.save(company);
    }

    @Override
    public CompanyDto findById(Long companyId) {
        Company company = companyRepository.findById(companyId).orElseThrow(() -> new NoSuchElementException("Invalid company ID"));
        return convertToDto(company);
    }

    @Override
    public void editCompany(CompanyDto company) {
        Company company1 = companyRepository.findById(company.getId())
                .orElseThrow(() -> new NoSuchElementException("Invalid company ID"));
        company1.setName(company.getName());
        company1.setInn(company.getInn());
        company1.setDirectorInn(company.getDirectorInn());
        company1.setLogin(company.getLogin());
        company1.setPassword(company.getPassword());
        company1.setEcp(company.getEcp());
        company1.setKabinetSalyk(company.getKabinetSalyk());
        company1.setKabinetSalykPassword(company.getKabinetSalykPassword());
        company1.setTaxMode(company.getTaxMode());
        company1.setOpf(company.getOpf());
        company1.setDistrictGns(company.getDistrictGns());
        company1.setSocfundNumber(company.getSocfundNumber());
        company1.setRegistrationNumberMj(company.getRegistrationNumberMj());
        company1.setOkpo(company.getOkpo());
        company1.setDirector(company.getDirector());
        company1.setKed(company.getKed());
        company1.setEmail(company.getEmail());
        company1.setEmailPassword(company.getEmailPassword());
        company1.setPhone(company.getPhone());
        company1.setEsf(company.getEsf());
        company1.setEsfPassword(company.getEsfPassword());
        company1.setKkm(company.getKkm());
        company1.setKkmPassword(company.getKkmPassword());
        company1.setFresh1c(company.getFresh1c());
        company1.setFresh1cPassword(company.getFresh1cPassword());
        company1.setEttn(company.getEttn());
        company1.setEttnPassword(company.getEttnPassword());
        companyRepository.save(company1);
    }


    @Override
    public void deleteCompany(Long companyId) {
        companyRepository.deleteById(companyId);
    }

    @Override
    public List<CompanyDto> getAllCompanies() {
        List<Company> companyList = companyRepository.findAll();
        return companyList.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    private CompanyDto convertToDto(Company company) {
        return CompanyDto.builder()
                .id(company.getId())
                .name(company.getName())
                .inn(company.getInn())
                .directorInn(company.getDirectorInn())
                .login(company.getLogin())
                .password(company.getPassword())
                .ecp(company.getEcp())
                .kabinetSalyk(company.getKabinetSalyk())
                .kabinetSalykPassword(company.getKabinetSalykPassword())
                .taxMode(company.getTaxMode())
                .opf(company.getOpf())
                .districtGns(company.getDistrictGns())
                .socfundNumber(company.getSocfundNumber())
                .registrationNumberMj(company.getRegistrationNumberMj())
                .okpo(company.getOkpo())
                .director(company.getDirector())
                .ked(company.getKed())
                .email(company.getEmail())
                .emailPassword(company.getEmailPassword())
                .phone(company.getPhone())
                .esf(company.getEsf())
                .esfPassword(company.getEsfPassword())
                .kkm(company.getKkm())
                .kkmPassword(company.getKkmPassword())
                .fresh1c(company.getFresh1c())
                .fresh1cPassword(company.getFresh1cPassword())
                .ettn(company.getEttn())
                .ettnPassword(company.getEttnPassword())
                .build();
    }

    private Company convertToEntity(CompanyDto companyDto) {
        return Company.builder()
                .name(companyDto.getName())
                .inn(companyDto.getInn())
                .directorInn(companyDto.getDirectorInn())
                .login(companyDto.getLogin())
                .password(companyDto.getPassword())
                .ecp(companyDto.getEcp())
                .kabinetSalyk(companyDto.getKabinetSalyk())
                .kabinetSalykPassword(companyDto.getKabinetSalykPassword())
                .taxMode(companyDto.getTaxMode())
                .opf(companyDto.getOpf())
                .districtGns(companyDto.getDistrictGns())
                .socfundNumber(companyDto.getSocfundNumber())
                .registrationNumberMj(companyDto.getRegistrationNumberMj())
                .okpo(companyDto.getOkpo())
                .director(companyDto.getDirector())
                .ked(companyDto.getKed())
                .email(companyDto.getEmail())
                .emailPassword(companyDto.getEmailPassword())
                .phone(companyDto.getPhone())
                .esf(companyDto.getEsf())
                .esfPassword(companyDto.getEsfPassword())
                .kkm(companyDto.getKkm())
                .kkmPassword(companyDto.getKkmPassword())
                .fresh1c(companyDto.getFresh1c())
                .fresh1cPassword(companyDto.getFresh1cPassword())
                .ettn(companyDto.getEttn())
                .ettnPassword(companyDto.getEttnPassword())
                .build();
    }

}
