package kg.attractor.financial_statement.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping()
@RequiredArgsConstructor
public class AuthController {

    @GetMapping("login")
    public String login() {
        return "auth/login";
    }
}
