package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.entity.UserCompany;
import kg.attractor.financial_statement.repository.CompanyRepository;
import kg.attractor.financial_statement.repository.UserCompanyRepository;
import kg.attractor.financial_statement.repository.UserRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CompanyServiceImplTest {

    @Mock
    private CompanyRepository companyRepository;

    @InjectMocks
    private CompanyServiceImpl companyService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserCompanyRepository companyUserRepository;


//    @Test переделать
//    void createCompany() {
//        CompanyDto companyDto = CompanyDto.builder()
//                .id(1L)
//                .name("YouTube")
//                .inn("12121")
//                .directorInn("122312")
//                .login("youtube.com")
//                .password("Qwerty123")
//                .ecp("3edfww23")
//                .kabinetSalyk("YouTube.salyk.kg")
//                .kabinetSalykPassword("Wertw23")
//                .taxMode("Free")
//                .opf("Some")
//                .districtGns("Manas")
//                .socfundNumber("N231231")
//                .registrationNumberMj("123sd")
//                .okpo("KDqre")
//                .director("vsfw")
//                .ked("fvswadfs")
//                .email("Lolo@mail.ru")
//                .emailPassword("JHsdicsfow")
//                .phone("9333322")
//                .esf("3csvw")
//                .esfPassword("svwada")
//                .kkm("frsfsafw.kkm")
//                .kkmPassword("Kdewfdew")
//                .fresh1c("1clogin")
//                .fresh1cPassword("1cpasw")
//                .ettn("sfewfwe.log")
//                .ettnPassword("fdsfsf.pas")
//                .build();
//
//        Company company = Company.builder()
//                .id(1L)
//                .name("YouTube")
//                .inn("12121")
//                .directorInn("122312")
//                .login("youtube.com")
//                .password("Qwerty123")
//                .ecp("3edfww23")
//                .kabinetSalyk("YouTube.salyk.kg")
//                .kabinetSalykPassword("Wertw23")
//                .taxMode("Free")
//                .opf("Some")
//                .districtGns("Manas")
//                .socfundNumber("N231231")
//                .registrationNumberMj("123sd")
//                .okpo("KDqre")
//                .director("vsfw")
//                .ked("fvswadfs")
//                .email("Lolo@mail.ru")
//                .emailPassword("JHsdicsfow")
//                .phone("9333322")
//                .esf("3csvw")
//                .esfPassword("svwada")
//                .kkm("frsfsafw.kkm")
//                .kkmPassword("Kdewfdew")
//                .fresh1c("1clogin")
//                .fresh1cPassword("1cpasw")
//                .ettn("sfewfwe.log")
//                .ettnPassword("fdsfsf.pas")
//                .build();
//
//        User user = User.builder()
//                .id(1L)
//                .login("babySharkDODO@gmail.com")
//                .password("password")
//                .build();
//
//        UserCompany userCompany = UserCompany.builder()
//                .user(user)
//                .company(company)
//                .build();
//
//        Mockito.when(companyRepository.save(any(Company.class))).thenReturn(company);
//        Mockito.when(userRepository.findByLogin(anyString())).thenReturn(Optional.of(user));
//        Mockito.when(companyUserRepository.save(any(UserCompany.class))).thenReturn(userCompany);
//
//        companyService.createCompany(companyDto, "babySharkDODO@gmail.com");
//
//        Mockito.verify(companyRepository, times(1)).save(any(Company.class));
//        Mockito.verify(userRepository, times(1)).findByLogin("babySharkDODO@gmail.com");
//        Mockito.verify(companyUserRepository, times(1)).save(any(UserCompany.class));
//    }

    @Test
    void findById() {
        Company company = Company.builder()
                .id(1L)
                .name("YouTube")
                .inn("12121")
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
                .inn("12121")
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

        CompanyDto companyDto = CompanyDto.builder()
                .id(1L)
                .name("YouTube")
                .inn("12121")
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

    @Test
    void deleteCompany() {
        Mockito.doNothing().when(companyRepository).changeIsDeleted(anyLong(), eq(Boolean.TRUE));
        companyService.deleteCompany(1L);
        Mockito.verify(companyRepository, times(1)).changeIsDeleted(1L, Boolean.TRUE);
    }

    @Test
    void getAllCompanies() {
        Company company1 = Company.builder()
                .id(1L)
                .name("YouTube")
                .inn("12121")
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

        Company company2 = Company.builder()
                .id(2L)
                .name("Telegram")
                .inn("2112121")
                .directorInn("12532312")
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
