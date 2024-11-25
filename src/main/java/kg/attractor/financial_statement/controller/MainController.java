package kg.attractor.financial_statement.controller;

import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.TaskService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.time.LocalDate;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping()
public class MainController {

    private final UserService userService;
    private final TaskService taskService;

    @GetMapping
    public String getMainPage( Model model, HttpServletRequest request) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String login = auth.getName();
        User userDto = userService.getUserByLogin(login);
        model.addAttribute("userDto", userDto);
        if (userDto == null) {
            return "redirect:/login";
        }
        CsrfToken csrfToken = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
        model.addAttribute("csrfToken", csrfToken);
        return "main/mainPage";
    }

    @PostMapping("/calendar")
    public ResponseEntity<Map<LocalDate, Long>> getTaskCounts(@RequestBody Map<String, Integer> yearMonth, Principal principal) {
        return taskService.countOfTaskForDay(yearMonth,principal.getName());
    }

}
