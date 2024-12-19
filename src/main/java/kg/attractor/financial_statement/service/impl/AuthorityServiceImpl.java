//package kg.attractor.financial_statement.service.impl;
//
//import kg.attractor.financial_statement.dto.AuthorityDto;
//import kg.attractor.financial_statement.entity.Authority;
//import kg.attractor.financial_statement.repository.AuthorityRepository;
//import kg.attractor.financial_statement.service.AuthorityService;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Service;
//import java.util.List;
//
//@Slf4j
//@RequiredArgsConstructor
//@Service
//public class AuthorityServiceImpl implements AuthorityService {
//    private final AuthorityRepository authorityRepository;
//
//    @Override
//    public List<Authority> findAllById(List<Long> id) {
//        return authorityRepository.findAllById(id);
//    }
//
//    @Override
//    public List<AuthorityDto> getAll() {
//        return authorityRepository.findAll()
//                .stream().map(this::convertToDto)
//                .toList();
//    }
//
//    private AuthorityDto convertToDto(Authority authority) {
//        return AuthorityDto.builder()
//                .id(authority.getId())
//                .authority(authority.getAuthority())
//                .authorityName(authority.getAuthorityName())
//                .selected(false)
//                .build();
//    }
//}
