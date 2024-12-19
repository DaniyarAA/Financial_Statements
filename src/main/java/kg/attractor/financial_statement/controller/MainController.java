//package kg.attractor.financial_statement.controller;
//
//import jakarta.servlet.http.HttpServletRequest;
//import kg.attractor.financial_statement.dto.PriorityDto;
//import kg.attractor.financial_statement.dto.TaskDto;
//import kg.attractor.financial_statement.entity.User;
//import kg.attractor.financial_statement.service.CompanyService;
//import kg.attractor.financial_statement.service.PriorityService;
//import kg.attractor.financial_statement.service.TaskService;
//import kg.attractor.financial_statement.service.UserService;
//import kg.attractor.financial_statement.utils.DateUtils;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.security.web.csrf.CsrfToken;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//import java.security.Principal;
//import java.time.LocalDate;
//import java.util.List;
//import java.util.Map;
//
//@Controller
//@RequiredArgsConstructor
//@RequestMapping()
//public class MainController {
//    private final UserService userService;
//    private final TaskService taskService;
//    private final PriorityService priorityService;
//    private final CompanyService companyService;
//
//    @GetMapping
//    public String getMainPage(@RequestParam(required = false, defaultValue = "desc") String sort,
//                              @RequestParam(required = false, defaultValue = "endDate") String sortBy,
//                              Model model, HttpServletRequest request) {
//        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//        String login = auth.getName();
//        User userDto = userService.getUserByLogin(login);
//
//        if (userDto == null) {
//            return "redirect:/login";
//        }
//        List<TaskDto> userTasks = taskService.getAllTasksForUserSorted(userDto, sortBy, sort);
//        List<PriorityDto> priorities = priorityService.getAllPriorities();
//
//        model.addAttribute("userTasks", userTasks);
//
//        CsrfToken csrfToken = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
//        model.addAttribute("csrfToken", csrfToken);
//
//        model.addAttribute("companies", companyService.getAllCompanies());
//        model.addAttribute("userDto", userDto);
//        model.addAttribute("dateUtils", new DateUtils());
//        model.addAttribute("sort", sort);
//        model.addAttribute("sortBy", sortBy);
//        model.addAttribute("priorities", priorities);
//
//        return "main/mainPage";
//    }
//
//    @PostMapping("/calendar")
//    public ResponseEntity<Map<LocalDate, Long>> getTaskCounts(@RequestBody Map<String, Integer> yearMonth, Principal principal) {
//        return taskService.countOfTaskForDay(yearMonth,principal);
//    }
//}
