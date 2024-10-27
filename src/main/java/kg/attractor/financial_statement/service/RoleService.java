package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.CreateRoleDto;
import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.entity.Role;

import java.util.List;

public interface RoleService {
    List<RoleDto> getAll();

    Role getRoleById(Long id);

    RoleDto getRoleByName(String name);

    RoleDto convertToDto(Role role);

    void createNewRole(CreateRoleDto createRoleDto);

    boolean checkIfRoleNameExists(String roleName);
}
