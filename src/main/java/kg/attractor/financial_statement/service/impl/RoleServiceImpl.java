package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.dto.RoleDto;
import kg.attractor.financial_statement.entity.Role;
import kg.attractor.financial_statement.repository.RoleRepository;
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

    @Override
    public List<RoleDto> getAll() {
        return roleRepository.findAll()
                .stream()
                .map(this::convertToDto)
                .toList();
    }

    private RoleDto convertToDto(Role role) {
        return RoleDto.builder()
                .id(role.getId())
                .roleName(role.getRoleName())
                .build();
    }
}
