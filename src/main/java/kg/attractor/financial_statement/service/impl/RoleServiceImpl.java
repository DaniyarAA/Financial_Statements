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
                .map(this::convertToDto)
                .toList();
    }

    @Override
    public Role getRoleById(Long id) {
        return roleRepository.findById(id).orElseThrow();
    }

    @Override
    public RoleDto getRoleByName(String name) {
        return convertToDto(roleRepository.findByRoleName(name).orElseThrow());
    }

    public RoleDto convertToDto(Role role) {
        List<AuthorityDto> allAuthorities = authorityService.getAll().stream()
                .map(auth -> new AuthorityDto(
                        auth.getId(),
                        auth.getAuthority(),
                        auth.getAuthorityName(),
                        role.getAuthorities().contains(auth)
                ))
                .toList();
        return RoleDto.builder()
                .id(role.getId())
                .roleName(role.getRoleName())
                .authorities(allAuthorities)
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

        role.setRoleName(roleDto.getRoleName());

        List<Authority> authorities = authorityService.findAllById(roleDto.getAuthorities().stream()
                .map(AuthorityDto::getId).toList());
        role.setAuthorities(authorities);
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
