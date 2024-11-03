package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.AuthorityDto;
import kg.attractor.financial_statement.dto.CreateRoleDto;
import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.entity.Authority;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.repository.RoleRepository;
import kg.attractor.financial_statement.service.AuthorityService;
import kg.attractor.financial_statement.service.RoleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;
    private final AuthorityService authorityService;

    @Override
    public List<RoleDto> getAll() {
        return roleRepository.findAll()
                .stream()
                .sorted(Comparator.comparing(Role::getId))
                .map(this::convertToDto)
                .toList();
    }

    @Override
    public Role getRoleById(Long id) {
        return roleRepository.findById(id).orElseThrow();
    }

    @Override
    public RoleDto getRoleDtoById(Long id) {
        return convertToDto(roleRepository.findById(id).orElseThrow());
    }

    @Override
    public RoleDto getRoleByName(String name) {
        return convertToDto(roleRepository.findByRoleName(name).orElseThrow());
    }

    public RoleDto convertToDto(Role role) {
        List<AuthorityDto> authorities = role.getAuthorities().stream()
                .map(auth -> new AuthorityDto(auth.getId(),
                        auth.getAuthority(),
                        auth.getAuthorityName(),
                        true))
                .toList();

        return RoleDto.builder()
                .id(role.getId())
                .roleName(role.getRoleName())
                .authorities(authorities)
                .userIds(role.getUsers().stream().map(User::getId).toList())
                .build();
    }

    @Override
    public void createNewRole(CreateRoleDto createRoleDto) {
        List<Authority> authorities = authorityService.findAllById(createRoleDto.getAuthorityIds());
        Role role = new Role();
        role.setRoleName(createRoleDto.getRoleName());
        role.setAuthorities(authorities);
        authorities.forEach(authority -> authority.getRoles().add(role));
        roleRepository.save(role);
    }

    @Override
    public void updateRole(Long roleId, RoleDto roleDto) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new NoSuchElementException("Role not found"));

        if (roleDto.getRoleName() == null || roleDto.getRoleName().trim().isEmpty()) {
            throw new IllegalArgumentException("Имя роли не может быть пустым.");
        }

        if (!role.getRoleName().equals(roleDto.getRoleName())) {
            boolean roleNameExists = roleRepository.findByRoleName(roleDto.getRoleName()).isPresent();
            if (roleNameExists) {
                throw new IllegalArgumentException("Роль с таким именем уже существует.");
            }
        }

        if (roleDto.getAuthorities() == null || roleDto.getAuthorities().isEmpty()) {
            throw new IllegalArgumentException("Роль должна иметь хотя бы одну привилегию.");
        }

        role.setRoleName(roleDto.getRoleName());

        List<Long> newAuthorityIds = roleDto.getAuthorities()
                .stream().map(AuthorityDto::getId).toList();

        role.getAuthorities().removeIf(authority -> !newAuthorityIds.contains(authority.getId()));

        List<Authority> authoritiesToAdd = authorityService.findAllById(newAuthorityIds)
                .stream()
                .filter(authority -> !role.getAuthorities().contains(authority))
                .toList();
        role.getAuthorities().addAll(authoritiesToAdd);
        authoritiesToAdd.forEach(authority -> authority.getRoles().add(role));
        roleRepository.save(role);
    }

    @Override
    @Transactional
    public void deleteRole(Long roleId) {
        Role role = roleRepository.findById(roleId).orElseThrow();
        role.getAuthorities().forEach(authority -> authority.getRoles().remove(role));
        role.setAuthorities(new ArrayList<>());
        roleRepository.deleteById(roleId);
    }

    @Override
    public boolean checkIfRoleNameExists(String roleName) {
        return roleRepository.findByRoleName(roleName).isPresent();
    }
}
