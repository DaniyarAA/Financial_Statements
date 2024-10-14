package kg.attractor.financial_statement.service;

import kg.attractor.financial_statement.dto.UserForTaskDto;

public interface UserService {
    UserForTaskDto getUserForTaskDto(Long id);
}
