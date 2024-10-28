package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.entity.Authority;
import kg.attractor.financial_statement.repository.AuthorityRepository;
import kg.attractor.financial_statement.service.AuthorityService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class AuthorityServiceImpl implements AuthorityService {
    private final AuthorityRepository authorityRepository;

    @Override
    public List<Authority> findAllById(List<Long> id) {
        return authorityRepository.findAllById(id);
    }
}
