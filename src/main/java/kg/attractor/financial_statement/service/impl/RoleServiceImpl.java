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
import kg.attractor.financial_statement.service.RoleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

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
                .filter(role -> !"SuperUser".equals(role.getRoleName()))
                .sorted((role1, role2) -> {
                    boolean canDelete1 = role1.getUsers().isEmpty();
                    boolean canDelete2 = role2.getUsers().isEmpty();

                    if (canDelete1 && !canDelete2) {
                        return 1;
                    } else if (!canDelete1 && canDelete2) {
                        return -1;
                    } else {
                        return role1.getId().compareTo(role2.getId());
                    }
                })
                .map(this::convertToDto)
                .toList();
    }

    @Override
    public Role getRoleById(Long id) {
        log.info("get user by id{}", id);
        return roleRepository.findById(id).orElseThrow(() ->
                new NotFoundRoleException("can not find role with id " + id));
    }

    @Override
    public RoleDto getRoleDtoById(Long id) {
        return convertToDto(getRoleById(id));
    }

    @Override
    public RoleDto getRoleByName(String name) {
        log.info("get user by name{}", name);
        return convertToDto(roleRepository.findByRoleName(name).orElseThrow(()
                -> new NotFoundRoleException("Can not find role with name " + name)));
    }

    public RoleDto convertToDto(Role role) {
        if (role == null) {
            throw new IllegalArgumentException("Role cannot be null");
        }

        List<AuthorityDto> authorities = Optional.ofNullable(role.getAuthorities())
                .orElse(Collections.emptyList())
                .stream()
                .map(auth -> new AuthorityDto(auth.getId(),auth.getAuthority(), auth.getAuthorityName(), true))
                .toList();
        return RoleDto.builder()
                .id(role.getId())
                .roleName(role.getRoleName())
                .authorities(authorities)
                .userIds(Optional.ofNullable(role.getUsers())
                        .orElse(Collections.emptyList())
                        .stream()
                        .map(User::getId)
                        .toList())
                .build();
    }

    @Override
    public void createNewRole(CreateRoleDto createRoleDto) {
        if (createRoleDto.getAuthorityIds() == null || createRoleDto.getAuthorityIds().isEmpty()) {
            throw new IllegalArgumentException("Роль должна иметь хотя бы одну привилегию.");
        }
        Role role = new Role();
        role.setRoleName(createRoleDto.getRoleName());
        List<Authority> authorities = authorityService.findAllById(createRoleDto.getAuthorityIds());
        role.setAuthorities(authorities);
        authorities.forEach(authority -> {
            if (authority.getRoles() == null) {
                authority.setRoles(new ArrayList<>());
            }
            authority.getRoles().add(role);
        });
        log.info("created new role {} successfully", createRoleDto.getRoleName());
        roleRepository.save(role);
    }

    @Override
    public void updateRole(Long roleId, RoleDto roleDto) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new NotFoundRoleException("Роль не найдена"));

        if ("SuperUser".equals(role.getRoleName())) {
            log.info("Роль 'SuperUser' нельзя редактировать или удалять.");
            throw new IllegalArgumentException("Роль 'SuperUser' нельзя редактировать или удалять.");
        }

        if ("Бухгалтер".equalsIgnoreCase(role.getRoleName()) &&
            !role.getRoleName().equalsIgnoreCase(roleDto.getRoleName())) {
            log.info("Имя роли 'Бухгалтер' нельзя изменить.");
            throw new WrongRoleNameException("Имя роли 'Бухгалтер' нельзя изменить.");
        }

        if (roleDto.getRoleName() == null || roleDto.getRoleName().trim().isEmpty()) {
            log.info("Имя роли не может быть пустым.");
            throw new IllegalArgumentException("Имя роли не может быть пустым.");
        }

        if (!role.getRoleName().equalsIgnoreCase(roleDto.getRoleName())) {
            boolean roleNameExists = roleRepository.findByRoleName(roleDto.getRoleName()).isPresent();
            if (roleNameExists) {
                log.info("Роль с таким именем уже существует.");
                throw new IllegalArgumentException("Роль с таким именем уже существует.");
            }
        }

        if (roleDto.getAuthorities() == null || roleDto.getAuthorities().isEmpty()) {
            log.info("Роль должна иметь хотя бы одну привилегию.");
            throw new IllegalArgumentException("Роль должна иметь хотя бы одну привилегию.");
        }

        role.setRoleName(roleDto.getRoleName());

        List<Long> newAuthorityIds = roleDto.getAuthorities()
                .stream().map(AuthorityDto::getId).toList();

        List<Authority> authoritiesToRemove = role.getAuthorities().stream()
                .filter(authority -> !newAuthorityIds.contains(authority.getId()))
                .toList();
        for (Authority authority : authoritiesToRemove) {
            role.getAuthorities().remove(authority);
            authority.getRoles().remove(role);
        }

        List<Authority> authoritiesToAdd = authorityService.findAllById(newAuthorityIds)
                .stream()
                .filter(authority -> !role.getAuthorities().contains(authority))
                .toList();
        role.getAuthorities().addAll(authoritiesToAdd);
        authoritiesToAdd.forEach(authority -> authority.getRoles().add(role));
        log.info("role {} updated successfully", role.getRoleName());
        roleRepository.save(role);
    }

    @Override
    @Transactional
    public void deleteRole(Long roleId) {
        Role role = roleRepository.findById(roleId).orElseThrow(() ->
                new NotFoundRoleException("Can not find role  for delete by id" + roleId));

        if ("Бухгалтер".equalsIgnoreCase(role.getRoleName())) {
            log.info("Роль 'Бухгалтер' нельзя удалить.");
            throw new IllegalArgumentException("Роль 'Бухгалтер' нельзя удалить.");
        }

        if (role.getUsers().isEmpty()) {
            role.getAuthorities().forEach(authority -> authority.getRoles().remove(role));
            role.setAuthorities(new ArrayList<>());
            log.info("role {} deleted successfully", role.getRoleName());
            roleRepository.deleteById(roleId);
        } else {
            log.info("Роль не может быть удалена, так как она назначена пользователям.");
            throw new IllegalArgumentException("Роль не может быть удалена, так как она назначена пользователям.");
        }
    }

    @Override
    public boolean checkIfRoleNameExists(String roleName) {
        return roleRepository.findByRoleName(roleName).isPresent();
    }
}