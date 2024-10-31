package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.repository.UserCompanyRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class PrivateUserCompanyService {
    @Autowired
    private UserCompanyRepository userCompanyRepository;


    public PrivateUserCompanyService(UserCompanyRepository userCompanyRepository) {
        this.userCompanyRepository = userCompanyRepository;
    }
}
