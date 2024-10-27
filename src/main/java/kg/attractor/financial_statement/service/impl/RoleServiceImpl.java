package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.CreateRoleDto;
import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.entity.Authority;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.repository.RoleRepository;
import kg.attractor.financial_statement.service.AuthorityService;
import kg.attractor.financial_statement.service.RoleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

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
    public Role getRoleById(Long id){
        return roleRepository.findById(id).orElseThrow();
    }

    @Override
    public RoleDto getRoleByName(String name){
        return convertToDto(roleRepository.findByRoleName(name).orElseThrow());
    }

    @Override
    public RoleDto convertToDto(Role role) {
        return RoleDto.builder()
                .id(role.getId())
                .roleName(role.getRoleName())
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
    public boolean checkIfRoleNameExists(String roleName) {
        return roleRepository.findByRoleName(roleName).isPresent();
    }
}
