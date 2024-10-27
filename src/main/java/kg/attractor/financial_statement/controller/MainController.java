package kg.attractor.financial_statement.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping()
public class MainController {
    @GetMapping
    public String getMainPage(Authentication authentication) {
        if (authentication == null) {
            return "redirect:/login";
        }
        return "main/mainPage";
    }
}
