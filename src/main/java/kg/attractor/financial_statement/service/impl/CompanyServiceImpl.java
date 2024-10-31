package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.dto.CompanyForTaskDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.CompanyRepository;
import kg.attractor.financial_statement.repository.UserCompanyRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.validation.EmailValidator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class CompanyServiceImpl implements CompanyService {
    private final CompanyRepository companyRepository;
    private final UserRepository userRepository;
    private final UserCompanyRepository companyUserRepository;

    @Override
    public ResponseEntity<Map<String, String>> createCompany(
            CompanyDto companyDto, String login, BindingResult bindingResult) {

        if (bindingResult != null && bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(error ->
                    errors.put(error.getField(), error.getDefaultMessage())
            );
            return ResponseEntity.badRequest().body(errors);
        }

        Company company = convertToEntity(companyDto);
        Company companyCreated = companyRepository.save(company);

        createdUserCompany(companyCreated, login);

        return ResponseEntity.ok(Map.of("message", companyCreated.getName() + " компания создана успешно !"));
    }

    @Override
    public CompanyDto findById(Long companyId) {
        Company company = companyRepository.findById(companyId).orElseThrow(() -> new NoSuchElementException("Нерабочая ID компании !"));
        return convertToDto(company);
    }

    @Override
    public void editCompany(CompanyDto company) {
        Company company1 = companyRepository.findById(company.getId())
                .orElseThrow(() -> new NoSuchElementException("Нерабочая ID компании !"));
        company1.setName(company.getName());
        company1.setInn(company.getCompanyInn());
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
        companyRepository.changeIsDeleted(companyId, Boolean.TRUE);
    }

    @Override
    public List<CompanyDto> getAllCompanies() {
        List<Company> companyList = companyRepository.findByIsDeleted(Boolean.FALSE);
        return companyList.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    @Override
    public ResponseEntity<Map<String, String>> editByOne(Map<String, String> data) {
        String companyIdStr = data.get("companyId");
        String fieldToEdit = data.get("field");
        String newValue = data.get("value");

        if (companyIdStr == null || fieldToEdit == null || newValue == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Неправильные вводные данные !"));
        }

        long companyId;
        try {
            companyId = Long.parseLong(companyIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Нерабочая ID компании !"));
        }

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new NoSuchElementException("Компания не найдена !"));

        switch (fieldToEdit) {
            case "email":
                if (EmailValidator.isValidEmail(newValue)) {
                    company.setEmail(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Неправильный формат Email !"));
                }
                break;
            case "emailPassword":
                company.setEmailPassword(newValue);
                break;
            case "phone":
                company.setPhone(newValue);
                break;
            case "esf":
                company.setEsf(newValue);
                break;
            case "esfPassword":
                company.setEsfPassword(newValue);
                break;
            case "kkm":
                company.setKkm(newValue);
                break;
            case "kkmPassword":
                company.setKkmPassword(newValue);
                break;
            case "fresh1c":
                company.setFresh1c(newValue);
                break;
            case "fresh1cPassword":
                company.setFresh1cPassword(newValue);
                break;
            case "ettn":
                company.setEttn(newValue);
                break;
            case "ettnPassword":
                company.setEttnPassword(newValue);
                break;
            case "name":
                company.setName(newValue);
                break;
            case "companyInn":
                company.setInn(newValue);
                break;
            case "directorInn":
                company.setDirectorInn(newValue);
                break;
            case "login":
                company.setLogin(newValue);
                break;
            case "password":
                company.setPassword(newValue);
                break;
            case "ecp":
                company.setEcp(newValue);
                break;
            case "kabinetSalyk":
                company.setKabinetSalyk(newValue);
                break;
            case "kabinetSalykPassword":
                company.setKabinetSalykPassword(newValue);
                break;
            case "taxMode":
                company.setTaxMode(newValue);
                break;
            case "opf":
                company.setOpf(newValue);
                break;
            case "districtGns":
                company.setDistrictGns(newValue);
                break;
            case "socfundNumber":
                company.setSocfundNumber(newValue);
                break;
            case "registrationNumberMj":
                company.setRegistrationNumberMj(newValue);
                break;
            case "okpo":
                company.setOkpo(newValue);
                break;
            case "director":
                company.setDirector(newValue);
                break;
            case "ked":
                company.setKed(newValue);
                break;
            default:
                return ResponseEntity.badRequest().body(Map.of("message", "Неизвестное значение редактирования !"));
        }


        companyRepository.save(company);

        return ResponseEntity.ok(Map.of("message", "Компания Успешно отредактирована."));
    }

    private void createdUserCompany(Company company, String login) {
        User user = userRepository.findByLogin(login)
                .orElseThrow(() -> new UsernameNotFoundException("Пользователь не найден ошибка создания user-company!"));
        UserCompany userCompany = new UserCompany();
        userCompany.setCompany(company);
        userCompany.setUser(user);
        companyUserRepository.save(userCompany);
    }

    @Override
    public CompanyDto convertToDto(Company company) {
        return CompanyDto.builder()
                .id(company.getId())
                .name(company.getName())
                .companyInn(company.getInn())
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

    @Override
    public Company getCompanyById(Long companyId) {
        return companyRepository.findById(companyId)
                .orElseThrow(() -> new NoSuchElementException("No such company found"));
    }

    @Override
    public CompanyForTaskDto getCompanyForTaskDto(Long id) {
        Company company = companyRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("No such company found with id: " + id));
        return convertToCompanyForTaskDto(company);
    }

    private Company convertToEntity(CompanyDto companyDto) {
        return Company.builder()
                .name(companyDto.getName())
                .inn(companyDto.getCompanyInn())
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

    private CompanyForTaskDto convertToCompanyForTaskDto(Company company) {
        return CompanyForTaskDto.builder()
                .name(company.getName())
                .inn(company.getInn())
                .build();
    }

}
