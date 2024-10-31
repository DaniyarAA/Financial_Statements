package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.repository.CompanyRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
@Slf4j
public class CompanyPrivateService {
    private final CompanyRepository companyRepository;

    public Company getCompanyById(Long companyId) {
        return companyRepository.findById(companyId)
                .orElseThrow(() -> new NoSuchElementException("No such company found"));
    }

    public CompanyDto convertToDto(Company company) {
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
}
