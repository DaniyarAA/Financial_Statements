package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.entity.Authority;

import java.util.List;

public interface AuthorityService {
    List<Authority> findAllById(List<Long> id);

    List<Authority> getAll();
}
