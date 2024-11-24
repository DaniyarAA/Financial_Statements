package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.AuthorityDto;
import kg.attractor.financial_statement.entity.Authority;
import kg.attractor.financial_statement.repository.AuthorityRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.AssertionsForInterfaceTypes.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AuthorityServiceImplTest {
    @Mock
    private AuthorityRepository authorityRepository;

    @InjectMocks
    private AuthorityServiceImpl authorityService;

    @Test
    void testFindAllById() {
        List<Long> ids = List.of(1L, 2L);
        Authority authority1 = new Authority();
        authority1.setId(1L);
        authority1.setAuthority("ROLE_USER");
        Authority authority2 = new Authority();
        authority2.setId(2L);
        authority2.setAuthority("ROLE_ADMIN");
        List<Authority> mockAuthorities = List.of(authority1, authority2);
        when(authorityRepository.findAllById(ids)).thenReturn(mockAuthorities);
        List<Authority> result = authorityService.findAllById(ids);
        assertThat(result).isEqualTo(mockAuthorities);
        verify(authorityRepository).findAllById(ids);
        verifyNoMoreInteractions(authorityRepository);
    }

    @Test
    void testGetAll() {
        Authority authority1 = new Authority();
        authority1.setId(1L);
        authority1.setAuthority("ROLE_USER");
        authority1.setAuthorityName("User Role");
        Authority authority2 = new Authority();
        authority2.setId(2L);
        authority2.setAuthority("ROLE_ADMIN");
        authority2.setAuthorityName("Admin Role");
        List<Authority> mockAuthorities = List.of(authority1, authority2);
        when(authorityRepository.findAll()).thenReturn(mockAuthorities);
        List<AuthorityDto> result = authorityService.getAll();
        assertThat(result).hasSize(2);
        assertThat(result).containsExactlyInAnyOrder(
                AuthorityDto.builder()
                        .id(1L)
                        .authority("ROLE_USER")
                        .authorityName("User Role")
                        .selected(false)
                        .build(),
                AuthorityDto.builder()
                        .id(2L)
                        .authority("ROLE_ADMIN")
                        .authorityName("Admin Role")
                        .selected(false)
                        .build()
        );

        verify(authorityRepository).findAll();
        verifyNoMoreInteractions(authorityRepository);
    }
}
