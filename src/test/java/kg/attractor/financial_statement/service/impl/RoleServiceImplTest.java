package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.AuthorityDto;
import kg.attractor.financial_statement.dto.CreateRoleDto;
import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.entity.Authority;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.error.NotFoundRoleException;
import kg.attractor.financial_statement.error.WrongRoleNameException;
import kg.attractor.financial_statement.repository.RoleRepository;
import kg.attractor.financial_statement.service.AuthorityService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import static org.assertj.core.api.AssertionsForInterfaceTypes.assertThat;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RoleServiceImplTest {

    @Mock
    private RoleRepository roleRepository;

    @Mock
    private AuthorityService authorityService;

    @Spy
    @InjectMocks
    private RoleServiceImpl roleService;

    private Role existingRole;

    @BeforeEach
    void setUp() {
        existingRole = new Role();
        existingRole.setId(1L);
        existingRole.setRoleName("TEST");
        Authority fakeAuthority = new Authority();
        fakeAuthority.setId(1L);
        fakeAuthority.setRoles(new ArrayList<>(List.of(existingRole)));
        existingRole.setAuthorities(new ArrayList<>(List.of(fakeAuthority)));
    }

    @Test
    void testReturnRoleDtoWhenRoleExists() {
        when(roleRepository.findByRoleName("TEST")).thenReturn(Optional.of(existingRole));
        RoleDto result = roleService.getRoleByName("TEST");
        assertNotNull(result, "RoleDto shouldn't be null");
        assertEquals("TEST", result.getRoleName(), "Role name must be TEST");
        assertEquals(1L, result.getId(), "Role ID  == " + result.getId());
        verify(roleRepository).findByRoleName("TEST");
    }

    @Test
    void testReturnTrueWhenRoleNameExists() {
        String roleName = "EXPERT";
        Role existingRole = new Role();
        existingRole.setRoleName(roleName);
        when(roleRepository.findByRoleName(roleName)).thenReturn(Optional.of(existingRole));
        boolean result = roleService.checkIfRoleNameExists(roleName);
        assertTrue(result, "Method should return true if role name exists");
        verify(roleRepository).findByRoleName(roleName);
    }

    @Test
    void testReturnFalseWhenRoleNameDoesNotExist() {
        String roleName = "EXPERT";
        when(roleRepository.findByRoleName(roleName)).thenReturn(Optional.empty());
        boolean result = roleService.checkIfRoleNameExists(roleName);
        assertFalse(result, "Method should return false if role name doesn't exist");
        verify(roleRepository).findByRoleName(roleName);
    }


    @Test
    void testAllRolesExcludingSuperUser() {
        Role superUserRole = new Role();
        superUserRole.setId(3L);
        superUserRole.setRoleName("SuperUser");
        superUserRole.setUsers(List.of());

        Role fakeRole = new Role();
        fakeRole.setId(2L);
        fakeRole.setRoleName("Admin");
        fakeRole.setUsers(List.of(new User()));

        Role fakeRole2 = new Role();
        fakeRole2.setId(3L);
        fakeRole2.setRoleName("User");
        fakeRole2.setUsers(List.of());

        List<Role> fakeRoles = List.of(superUserRole, fakeRole, fakeRole2);
        when(roleRepository.findAll()).thenReturn(fakeRoles);
        RoleDto roleDto1 = new RoleDto(2L, "Admin", List.of(), List.of(1L));
        RoleDto roleDto2 = new RoleDto(3L, "User", List.of(), List.of());
        doReturn(roleDto1).when(roleService).convertToDto(fakeRole);
        doReturn(roleDto2).when(roleService).convertToDto(fakeRole2);
        List<RoleDto> result = roleService.getAll();
        assertThat(result).containsExactly(roleDto1, roleDto2);
        assertThat(result).doesNotContain(new RoleDto(1L, "SuperUser", List.of(), List.of()));
        verify(roleRepository).findAll();
        verify(roleService).convertToDto(fakeRole);
        verify(roleService).convertToDto(fakeRole2);
        verifyNoMoreInteractions(roleRepository);
    }

    @Test
    void testGetRoleById_IfRoleExists() {
        Role fakeRole = new Role();
        fakeRole.setId(1L);
        fakeRole.setRoleName("TEST");
        when(roleRepository.findById(1L)).thenReturn(Optional.of(fakeRole));
        Role result = roleService.getRoleById(1L);
        assertThat(result).isEqualTo(fakeRole);
        verify(roleRepository).findById(1L);
        verifyNoMoreInteractions(roleRepository);
    }

    @Test
    void testThrowNotFoundRoleException_IfRoleDoesNotExist() {
        when(roleRepository.findById(1L)).thenReturn(Optional.empty());
        assertThrows(NotFoundRoleException.class, () -> roleService.getRoleById(1L));
        verify(roleRepository).findById(1L);
        verifyNoMoreInteractions(roleRepository);
    }

    @Test
    void testGetRoleDtoById_IfRoleExists() {
        Role fakeRole = new Role();
        fakeRole.setId(1L);
        fakeRole.setRoleName("TEST");
        RoleDto roleDto = roleService.convertToDto(fakeRole);
        when(roleRepository.findById(1L)).thenReturn(Optional.of(fakeRole));
        RoleDto result = roleService.getRoleDtoById(1L);
        assertThat(result).isEqualTo(roleDto);
        verify(roleRepository).findById(1L);
        verifyNoMoreInteractions(roleRepository);
    }



    @Test
    void testThrowNotFoundRoleException_IfRoleDtoDoesNotExist() {
        when(roleRepository.findById(1L)).thenReturn(Optional.empty());
        assertThrows(NotFoundRoleException.class, () -> roleService.getRoleDtoById(1L));
        verify(roleRepository).findById(1L);
        verifyNoMoreInteractions(roleRepository);
    }


    @Test
    void testCreateNewRole_Success() {
        CreateRoleDto createRoleDto = new CreateRoleDto();
        createRoleDto.setRoleName("TestRole");
        createRoleDto.setAuthorityIds(List.of(1L, 2L));
        Authority authority1 = new Authority();
        authority1.setId(1L);
        authority1.setAuthorityName("CREATE");
        authority1.setRoles(new ArrayList<>());
        Authority authority2 = new Authority();
        authority2.setId(2L);
        authority2.setAuthorityName("READ");
        authority2.setRoles(new ArrayList<>());
        List<Authority> authorityList = List.of(authority1, authority2);
        when(authorityService.findAllById(createRoleDto.getAuthorityIds())).thenReturn(authorityList);
        roleService.createNewRole(createRoleDto);
        verify(authorityService).findAllById(List.of(1L, 2L));
        ArgumentCaptor<Role> roleCaptor = ArgumentCaptor.forClass(Role.class);
        verify(roleRepository).save(roleCaptor.capture());
        Role savedRole = roleCaptor.getValue();
        assertThat(savedRole.getRoleName()).isEqualTo("TestRole");
        assertThat(savedRole.getAuthorities()).containsExactlyInAnyOrder(authority1, authority2);
        assertThat(authority1.getRoles()).contains(savedRole);
        assertThat(authority2.getRoles()).contains(savedRole);
        verifyNoMoreInteractions(roleRepository, authorityService);
    }

    @Test
    void testCreateNewRole_NoAuthorities_ThrowsException() {
        CreateRoleDto createRoleDto = new CreateRoleDto();
        createRoleDto.setRoleName("TestRole");
        createRoleDto.setAuthorityIds(List.of());
        Assertions.assertThrows(IllegalArgumentException.class, () -> roleService.createNewRole(createRoleDto));
        verifyNoInteractions(roleRepository);
    }

    @Test
    void testConvertRoleToRoleDto() {
        Authority fakeAuthority = new Authority(1L, "ROLE_READ", "Read Authority", new ArrayList<>());
        Authority fakeAuthority1 = new Authority(2L, "ROLE_WRITE", "Write Authority", new ArrayList<>());
        Role testRole = new Role();
        testRole.setId(1L);
        testRole.setRoleName("Admin");
        testRole.setAuthorities(List.of(fakeAuthority, fakeAuthority1));
        testRole.setUsers(new ArrayList<>());
        User fakeUser1 = new User(1L, "Test", "Testov", "test_testov", "superSecretPassword123!",
                true, LocalDate.now(), "avatar", LocalDate.now(), "not notes", true, "fakeEmail@gmail.com",testRole, new ArrayList<>());
        User fakeUser2 = new User(2L, "Test2", "Testova", "test2_testova", "anotherPassword123!",
                true, LocalDate.now(), "avatar2", LocalDate.now(), "other notes", true,"fakeSecondEmail@gmail.com", testRole, new ArrayList<>());
        testRole.setUsers(List.of(fakeUser1, fakeUser2));
        List<AuthorityDto> expectedAuthorities = List.of(
                new AuthorityDto(1L, "ROLE_READ", "Read Authority", true),
                new AuthorityDto(2L, "ROLE_WRITE", "Write Authority", true)
        );

        List<Long> expectedUserIds = List.of(1L, 2L);
        RoleDto result = roleService.convertToDto(testRole);
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getRoleName()).isEqualTo("Admin");
        assertThat(result.getAuthorities()).isEqualTo(expectedAuthorities);
        assertThat(result.getUserIds()).isEqualTo(expectedUserIds);
    }


    @Test
    void testIfConvertRoleWithEmptyAuthoritiesAndUsers() {
        Role role = new Role();
        role.setId(1L);
        role.setRoleName("Admin");
        role.setAuthorities(Collections.emptyList());
        role.setUsers(Collections.emptyList());
        RoleDto expectedDto = RoleDto.builder()
                .id(1L)
                .roleName("Admin")
                .authorities(Collections.emptyList())
                .userIds(Collections.emptyList())
                .build();
        RoleDto result = roleService.convertToDto(role);
        assertThat(result).isEqualTo(expectedDto);
    }

    @Test
    void testIfConvertRoleWithNullFields() {
        Role role = new Role();
        role.setId(1L);
        role.setRoleName(null);
        role.setAuthorities(null);
        role.setUsers(null);
        RoleDto expectedDto = RoleDto.builder()
                .id(1L)
                .roleName(null)
                .authorities(Collections.emptyList())
                .userIds(Collections.emptyList())
                .build();

        RoleDto result = roleService.convertToDto(role);
        assertThat(result).isEqualTo(expectedDto);
    }


    @Test
    void testThrowNotFoundRoleExceptionWhenRoleDoesNotExist() {
        Long roleId = 1L;
        when(roleRepository.findById(roleId)).thenReturn(Optional.empty());
        NotFoundRoleException exception = assertThrows(NotFoundRoleException.class,
                () -> roleService.deleteRole(roleId));
        assertEquals("Can not find role  for delete by id" + roleId, exception.getMessage());
        verify(roleRepository).findById(roleId);
        verifyNoMoreInteractions(roleRepository);
    }

    @Test
    void testThrowExceptionWhenDeletingRoleEqualsAccountantRole() {
        Long roleId = 1L;
        Role accountantTestRole = new Role();
        accountantTestRole.setId(roleId);
        accountantTestRole.setRoleName("Бухгалтер");
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(accountantTestRole));
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> roleService.deleteRole(roleId));
        assertEquals("Роль 'Бухгалтер' нельзя удалить.", exception.getMessage());
        verify(roleRepository).findById(roleId);
        verifyNoMoreInteractions(roleRepository);
    }

    @Test
    void testThrowExceptionWhenDeletingRoleAssignedToUsers() {
        Long roleId = 1L;
        Role testRole = new Role();
        testRole.setId(roleId);
        testRole.setRoleName("TEST");
        testRole.setUsers(List.of(new User()));
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(testRole));
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> roleService.deleteRole(roleId));
        assertEquals("Роль не может быть удалена, так как она назначена пользователям.", exception.getMessage());
        verify(roleRepository).findById(roleId);
        verifyNoMoreInteractions(roleRepository);
    }

    @Test
    void testForDeleteRoleSuccessfullyWhenNoUsersAssigned() {
        Long roleId = 1L;
        Role deletableRole = new Role();
        deletableRole.setId(roleId);
        deletableRole.setRoleName("TestRole");
        deletableRole.setUsers(Collections.emptyList());
        Authority testAuthority = new Authority();
        testAuthority.setRoles(new ArrayList<>(List.of(deletableRole)));
        Authority testAuthority2 = new Authority();
        testAuthority2.setRoles(new ArrayList<>(List.of(deletableRole)));
        deletableRole.setAuthorities(List.of(testAuthority, testAuthority2));
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(deletableRole));
        roleService.deleteRole(roleId);
        assertTrue(testAuthority.getRoles().isEmpty(), "testAuthority must have empty roles");
        assertTrue(testAuthority2.getRoles().isEmpty(), "testAuthority2 must have empty roles");
        verify(roleRepository).findById(roleId);
        verify(roleRepository).deleteById(roleId);
        verifyNoMoreInteractions(roleRepository);
    }

    @Test
    void testThrowExceptionWhenUpdatingAccountantRoleName() {
        Long roleId = 1L;
        Role existingRole = new Role();
        existingRole.setId(roleId);
        existingRole.setRoleName("Бухгалтер");
        RoleDto roleDto = new RoleDto();
        roleDto.setRoleName("NewName");
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(existingRole));
        WrongRoleNameException exception = assertThrows(WrongRoleNameException.class, ()
                -> roleService.updateRole(roleId, roleDto));
        assertEquals("Имя роли 'Бухгалтер' нельзя изменить.", exception.getMessage());
        verify(roleRepository).findById(roleId);
        verifyNoMoreInteractions(roleRepository, authorityService);
    }

    @Test
    void testToThrowExceptionWhenRoleNameIsNullOrEmpty() {
        Long roleId = 1L;
        Role existingRole = new Role();
        existingRole.setId(roleId);
        existingRole.setRoleName("TEST");
        RoleDto emptyName = new RoleDto();
        emptyName.setRoleName("");
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(existingRole));
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, ()
                -> roleService.updateRole(roleId, emptyName));

        assertEquals("Имя роли не может быть пустым.", exception.getMessage());
        verify(roleRepository).findById(roleId);
        verifyNoMoreInteractions(roleRepository, authorityService);
    }

    @Test
    void testToThrowExceptionWhenRoleNameAlreadyExists() {
        Long roleId = 1L;
        Role existingRole = new Role();
        existingRole.setId(roleId);
        existingRole.setRoleName("TEST");
        RoleDto duplicateRoleName = new RoleDto();
        duplicateRoleName.setRoleName("ExistingRole");
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(existingRole));
        when(roleRepository.findByRoleName("ExistingRole")).thenReturn(Optional.of(new Role()));
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> roleService.updateRole(roleId, duplicateRoleName));
        assertEquals("Роль с таким именем уже существует.", exception.getMessage());
        verify(roleRepository).findById(roleId);
        verify(roleRepository).findByRoleName("ExistingRole");
        verifyNoMoreInteractions(roleRepository, authorityService);
    }

    @Test
    void testToThrowExceptionWhenRoleHasNoAuthorities() {
        Long roleId = 1L;
        Role existingRole = new Role();
        existingRole.setId(roleId);
        existingRole.setRoleName("TEST");
        RoleDto noAuthoritiesDto = new RoleDto();
        noAuthoritiesDto.setRoleName("TEST");
        noAuthoritiesDto.setAuthorities(Collections.emptyList());
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(existingRole));
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, ()
                -> roleService.updateRole(roleId, noAuthoritiesDto));
        assertEquals("Роль должна иметь хотя бы одну привилегию.", exception.getMessage());
        verify(roleRepository).findById(roleId);
        verifyNoMoreInteractions(roleRepository, authorityService);
    }

    @Test
    void testToThrowExceptionWhenUpdatingSuperUserRole() {
        Long roleId = 1L;
        Role existingRole = new Role();
        existingRole.setId(roleId);
        existingRole.setRoleName("SuperUser");

        RoleDto roleDto = new RoleDto();
        roleDto.setRoleName("FakeRole");

        when(roleRepository.findById(roleId)).thenReturn(Optional.of(existingRole));

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () ->
                roleService.updateRole(roleId, roleDto));

        Assertions.assertEquals("Роль 'SuperUser' нельзя редактировать или удалять.", exception.getMessage());

        verify(roleRepository).findById(roleId);
        verifyNoMoreInteractions(roleRepository, authorityService);
    }


    @Test
    void testUpdateRoleSuccessfully() {
        Long roleId = 1L;
        Authority fakeAuthority2 = new Authority();
        fakeAuthority2.setId(2L);
        fakeAuthority2.setRoles(new ArrayList<>());
        RoleDto roleDto = new RoleDto();
        roleDto.setRoleName("UpdatedTEST");
        roleDto.setAuthorities(List.of(
                new AuthorityDto(2L, "CREATE_FAKE_AUTHORITY", "creating authorities", true)
        ));
        when(roleRepository.findById(roleId)).thenReturn(Optional.of(existingRole));
        when(roleRepository.findByRoleName("UpdatedTEST")).thenReturn(Optional.empty());
        when(authorityService.findAllById(List.of(2L))).thenReturn(List.of(fakeAuthority2));
        roleService.updateRole(roleId, roleDto);
        assertEquals("UpdatedTEST", existingRole.getRoleName(), "Имя роли должно быть обновлено");
        assertThat(existingRole.getAuthorities()).containsExactly(fakeAuthority2);
        assertThat(fakeAuthority2.getRoles()).contains(existingRole);
    }
}