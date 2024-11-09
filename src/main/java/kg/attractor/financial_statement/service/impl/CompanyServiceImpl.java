package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.dto.CompanyForTaskDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.CompanyRepository;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.UserCompanyService;
import kg.attractor.financial_statement.service.UserService;
import kg.attractor.financial_statement.validation.EmailValidator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class CompanyServiceImpl implements CompanyService {
    private final CompanyRepository companyRepository;
    private final UserCompanyService userCompanyService;
    private UserService userService;

    @Autowired
    @Lazy
    private void setUserService(UserService userService) {
        this.userService = userService;
    }


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
        company.setDeleted(Boolean.FALSE);
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
                if (newValue.length() < 30) {
                    company.setPhone(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер номера телефона не может быть больше 30"));
                }
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
                if (!existsByCompanyName(newValue)) {
                    company.setName(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Компания с таким именем уже существует , либо заорхивирована и можете восстановить !"));
                }
                break;
            case "companyInn":
                if (newValue.length() == 12) {
                    if (!existsByCompanyInn(newValue)) {
                        company.setInn(newValue);
                    } else {
                        return ResponseEntity.badRequest().body(Map.of("message", "Компания с таким ИНН уже существует!"));
                    }
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер ИНН должен быть 12 символов"));
                }
                break;
            case "directorInn":
                if (newValue.length() == 12) {
                    if (!existsByCompanyDirectorInn(newValue)) {
                        company.setDirectorInn(newValue);
                    }else {
                        return ResponseEntity.badRequest().body(Map.of("message", "Компания с таким ИНН директором уже существует!"));
                    }
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер ИНН должен быть 12 символов"));
                }
                break;
            case "login":
                if (!existsByCompanyLogin(newValue)) {
                    company.setLogin(newValue);
                }else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Компания с таким логином уже существует!"));
                }
                break;
            case "password":
                company.setPassword(newValue);
                break;
            case "ecp":
                company.setEcp(newValue);
                break;
            case "kabinetSalyk":
                if (!existsByCompanySalykLogin(newValue)){
                    company.setKabinetSalyk(newValue);
                }else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Компания с таким логином Salyk.kg уже существует!"));
                }
                break;
            case "kabinetSalykPassword":
                company.setKabinetSalykPassword(newValue);
                break;
            case "taxMode":
                if (newValue.length() < 75) {
                    company.setTaxMode(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер налогооблажения не может быть больше 75"));
                }
                break;
            case "opf":
                if (newValue.length() < 75) {
                    company.setOpf(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер ОПФ не может быть больше 75"));
                }
                break;
            case "districtGns":
                company.setDistrictGns(newValue);
                break;
            case "socfundNumber":
                if (newValue.length() == 12) {
                    company.setSocfundNumber(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Номер социального фонда должен быть 12 из символов"));
                }
                break;
            case "registrationNumberMj":
                if (newValue.length() < 50) {
                    company.setRegistrationNumberMj(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер регистрационного номера МЮ не может быть больше 50"));
                }
                break;
            case "okpo":
                if (newValue.length() == 8) {
                    company.setOkpo(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер ОКПО должен быть из 8 символов"));
                }
                break;
            case "director":
                company.setDirector(newValue);
                break;
            case "ked":
                if (newValue.length() < 50) {
                    company.setKed(newValue);
                } else {
                    return ResponseEntity.badRequest().body(Map.of("message", "Размер КЭД не может быть больше 50"));
                }
                break;
            default:
                return ResponseEntity.badRequest().body(Map.of("message", "Неизвестное значение редактирования !"));
        }


        companyRepository.save(company);

        return ResponseEntity.ok(Map.of("message", "Компания Успешно отредактирована."));
    }

    private void createdUserCompany(Company company, String login) {
        User user = userService.getUserByLogin(login);
        UserCompany userCompany = new UserCompany();
        userCompany.setCompany(company);
        userCompany.setUser(user);
        userCompanyService.save(userCompany);
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
                .isDeleted(company.isDeleted())
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

    @Override
    public Company convertToEntity(CompanyDto companyDto) {
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

    @Override
    public List<CompanyDto> getAllCompaniesBySort(String sort) {
        final String ARCHIVE = "archive";
        List<Company> companyList = Collections.emptyList();

        if (sort != null) {
            if (sort.equalsIgnoreCase(ARCHIVE)) {
                companyList = companyRepository.findByIsDeleted(Boolean.TRUE);
            } else {
                companyList = companyRepository.findByIsDeleted(Boolean.FALSE);
            }
        }

        return companyList.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public void returnCompany(Long companyId) {
        companyRepository.changeIsDeleted(companyId, Boolean.FALSE);
    }

    @Override
    public boolean existsByCompanyName(String companyName) {
        return companyRepository.existsByName(companyName);
    }

    @Override
    public List<CompanyDto> findByName(String search) {
        List<Company> companyList = companyRepository.findByNameContainingIgnoreCase(search);
        return companyList.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByCompanyInn(String companyInn) {
        return companyRepository.existsByInn(companyInn);
    }

    @Override
    public boolean existsByCompanyDirectorInn(String companyDirectorInn) {
        return companyRepository.existsByDirectorInn(companyDirectorInn);
    }

    @Override
    public boolean existsByCompanyLogin(String companyLogin) {
        return companyRepository.existsByLogin(companyLogin);
    }

    @Override
    public boolean existsByCompanySalykLogin(String salykLogin) {
        return companyRepository.existsByKabinetSalyk(salykLogin);
    }


    private CompanyForTaskDto convertToCompanyForTaskDto(Company company) {
        return CompanyForTaskDto.builder()
                .name(company.getName())
                .inn(company.getInn())
                .build();
    }

}
