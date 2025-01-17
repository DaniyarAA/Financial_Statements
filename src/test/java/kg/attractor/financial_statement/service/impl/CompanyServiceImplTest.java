package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.repository.CompanyRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;

import java.util.*;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CompanyServiceImplTest {

    @Mock
    private CompanyRepository companyRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private CompanyServiceImpl companyService;

    @Mock
    private BindingResult bindingResult;

    @Test
    void createCompanyWithNotValidLogin() {
        CompanyDto companyDto = new CompanyDto();

        ResponseEntity<Map<String, String>> response = companyService.createCompany(companyDto, "", bindingResult);

        Assertions.assertEquals(400, response.getStatusCodeValue());
        Assertions.assertEquals("Авторизуйтесь чтобы создать компанию !", response.getBody().get("message"));
    }

    @Test
    void createCompanyWithBindingResultHasError() {
        CompanyDto companyDto = new CompanyDto();
        Mockito.when(bindingResult.hasErrors()).thenReturn(true);
        Mockito.when(bindingResult.getFieldErrors()).thenReturn(List.of(new FieldError("companyDto", "name", "Name is required")));

        ResponseEntity<Map<String, String>> response = companyService.createCompany(companyDto, "userLogin", bindingResult);

        Assertions.assertEquals(400, response.getStatusCodeValue());
        Assertions.assertEquals("Name is required", response.getBody().get("name"));
    }

    @Test
    void findById() {
        Company company = Company.builder()
                .id(1L)
                .name("YouTube")
                .inn("123456789012")
                .directorInn("123456789012")
                .login("youtube.com")
                .password("Qwerty123")
                .ecp("3edfww23")
                .kabinetSalyk("YouTube.salyk.kg")
                .kabinetSalykPassword("Wertw23")
                .taxMode("Free")
                .opf("Some")
                .districtGns("Manas")
                .socfundNumber("N231231")
                .registrationNumberMj("123sd")
                .okpo("KDqre")
                .director("vsfw")
                .ked("fvswadfs")
                .email("Lolo@mail.ru")
                .emailPassword("JHsdicsfow")
                .phone("9333322")
                .esf("3csvw")
                .esfPassword("svwada")
                .kkm("frsfsafw.kkm")
                .kkmPassword("Kdewfdew")
                .fresh1c("1clogin")
                .fresh1cPassword("1cpasw")
                .ettn("sfewfwe.log")
                .ettnPassword("fdsfsf.pas")
                .build();

        Mockito.when(companyRepository.findById(anyLong())).thenReturn(Optional.of(company));

        CompanyDto result = companyService.findById(1L);

        Assertions.assertNotNull(result);
        Assertions.assertEquals(1L, result.getId());
        Assertions.assertEquals("YouTube", result.getName());
    }

    @Test
    void findById_NotFound() {
        Mockito.when(companyRepository.findById(anyLong())).thenReturn(Optional.empty());

        Assertions.assertThrows(NoSuchElementException.class, () -> {
            companyService.findById(1L);
        });
    }

    @Test
    void editCompany() {
        Company company = Company.builder()
                .id(1L)
                .name("YouTube")
                .inn("123456789012")
                .directorInn("123456789012")
                .login("youtube.com")
                .password("Qwerty123")
                .ecp("3edfww23")
                .kabinetSalyk("YouTube.salyk.kg")
                .kabinetSalykPassword("Wertw23")
                .taxMode("Free")
                .opf("Some")
                .districtGns("Manas")
                .socfundNumber("N231231")
                .registrationNumberMj("123sd")
                .okpo("KDqre")
                .director("vsfw")
                .ked("fvswadfs")
                .email("Lolo@mail.ru")
                .emailPassword("JHsdicsfow")
                .phone("9333322")
                .esf("3csvw")
                .esfPassword("svwada")
                .kkm("frsfsafw.kkm")
                .kkmPassword("Kdewfdew")
                .fresh1c("1clogin")
                .fresh1cPassword("1cpasw")
                .ettn("sfewfwe.log")
                .ettnPassword("fdsfsf.pas")
                .build();

        CompanyDto companyDto = CompanyDto.builder()
                .id(1L)
                .name("YouTube")
                .companyInn("12121")
                .directorInn("122312")
                .login("youtube.com")
                .password("Qwerty123")
                .ecp("3edfww23")
                .kabinetSalyk("YouTube.salyk.kg")
                .kabinetSalykPassword("Wertw23")
                .taxMode("Free")
                .opf("Some")
                .districtGns("Manas")
                .socfundNumber("N231231")
                .registrationNumberMj("123sd")
                .okpo("KDqre")
                .director("vsfw")
                .ked("fvswadfs")
                .email("Lolo@mail.ru")
                .emailPassword("JHsdicsfow")
                .phone("9333322")
                .esf("3csvw")
                .esfPassword("svwada")
                .kkm("frsfsafw.kkm")
                .kkmPassword("Kdewfdew")
                .fresh1c("1clogin")
                .fresh1cPassword("1cpasw")
                .ettn("sfewfwe.log")
                .ettnPassword("fdsfsf.pas")
                .build();

        Mockito.when(companyRepository.findById(anyLong())).thenReturn(Optional.of(company));
        Mockito.when(companyRepository.save(any(Company.class))).thenReturn(company);

        companyService.editCompany(companyDto);

        Mockito.verify(companyRepository, times(1)).findById(1L);
        Mockito.verify(companyRepository, times(1)).save(any(Company.class));
    }

//    @Test
//    void deleteCompany() {
//        Mockito.doNothing().when(companyRepository).changeIsDeleted(anyLong(), eq(Boolean.TRUE));
//        Mockito.doNothing().when(userRepository).findByLogin(anyString());
//        companyService.deleteCompany(1L,"baqdoolot");
//        Mockito.verify(companyRepository, times(1)).changeIsDeleted(1L, Boolean.TRUE);
//    }

//    @Test
//    void returnCompany() {
//        Mockito.doNothing().when(companyRepository).changeIsDeleted(anyLong(), eq(Boolean.FALSE));
//        Mockito.doNothing().when(userRepository).findByLogin(anyString());
//        companyService.returnCompany(1L , "baqdoolot");
//        Mockito.verify(companyRepository, times(1)).changeIsDeleted(1L, Boolean.FALSE);
//    }

    @Test
    void getAllCompanies() {
        Company company1 = Company.builder()
                .id(1L)
                .name("YouTube")
                .inn("123456789012")
                .directorInn("123456789012")
                .login("youtube.com")
                .password("Qwerty123")
                .ecp("3edfww23")
                .kabinetSalyk("YouTube.salyk.kg")
                .kabinetSalykPassword("Wertw23")
                .taxMode("Free")
                .opf("Some")
                .districtGns("Manas")
                .socfundNumber("N231231")
                .registrationNumberMj("123sd")
                .okpo("KDqre")
                .director("vsfw")
                .ked("fvswadfs")
                .email("Lolo@mail.ru")
                .emailPassword("JHsdicsfow")
                .phone("9333322")
                .esf("3csvw")
                .esfPassword("svwada")
                .kkm("frsfsafw.kkm")
                .kkmPassword("Kdewfdew")
                .fresh1c("1clogin")
                .fresh1cPassword("1cpasw")
                .ettn("sfewfwe.log")
                .ettnPassword("fdsfsf.pas")
                .build();

        Company company2 = Company.builder()
                .id(2L)
                .name("Telegram")
                .inn("123456789012")
                .directorInn("123456789012")
                .login("tele.com")
                .password("Qwerty123")
                .ecp("3edfwdsw23")
                .kabinetSalyk("Tele.salyk.kg")
                .kabinetSalykPassword("Wescdrtw23")
                .taxMode("Free")
                .opf("Some")
                .districtGns("Kiev")
                .socfundNumber("N2332231")
                .registrationNumberMj("12332sd")
                .okpo("KDqrsde")
                .director("vsfdfw")
                .ked("fvswaddffs")
                .email("lolollo@mail.ru")
                .emailPassword("sfdsdfs")
                .phone("933332322")
                .esf("3csdfsvw")
                .esfPassword("svrwsgfwada")
                .kkm("frsfsfsafw.kkm")
                .kkmPassword("Kvsdewfdew")
                .fresh1c("1clvsogin")
                .fresh1cPassword("1cpweasw")
                .ettn("sfewwefwe.log")
                .ettnPassword("fdsfksf.pas")
                .build();

        Mockito.when(companyRepository.findByIsDeleted(Boolean.FALSE)).thenReturn(Arrays.asList(company1, company2));

        List<CompanyDto> result = companyService.getAllCompanies();

        Assertions.assertNotNull(result);
        Assertions.assertEquals(2, result.size());
    }
}
