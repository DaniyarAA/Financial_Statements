//package kg.attractor.financial_statement.service.impl;
//
//import kg.attractor.financial_statement.dto.PriorityDto;
//import kg.attractor.financial_statement.repository.PriorityRepository;
//import kg.attractor.financial_statement.service.PriorityService;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//import java.util.stream.Collectors;
//
//@Service
//@RequiredArgsConstructor
//@Slf4j
//public class PriorityServiceImpl implements PriorityService {
//    private final PriorityRepository priorityRepository;
//
//    @Override
//    public List<PriorityDto> getAllPriorities() {
//        return priorityRepository.findAll().stream()
//                .map(priority -> PriorityDto.builder()
//                        .id(priority.getId())
//                        .name(priority.getName())
//                        .build())
//                .collect(Collectors.toList());
//    }
//}
