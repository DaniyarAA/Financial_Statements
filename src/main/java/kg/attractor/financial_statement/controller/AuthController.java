package kg.attractor.financial_statement.controller;

import jakarta.servlet.http.HttpServletRequest;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping()
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;

    @GetMapping("login")
    public String login(HttpServletRequest request, Model model) {
        try {
            UserDto userDto = userService.getUserDtoByCookie(request);
            if (userDto != null) {
                model.addAttribute("username", userDto.getName());
                model.addAttribute("avatar", userDto.getAvatar());
            }
            return "auth/login";
        } catch (Exception e) {
            System.err.println("Exception occurred in login method: " + e.getMessage());
            return "auth/login";
        }
    }
}