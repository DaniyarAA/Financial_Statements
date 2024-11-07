package kg.attractor.financial_statement.controller;

import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping()
public class MainController {

    private final UserService userService;

    @GetMapping
    public String getMainPage( Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String login = auth.getName();
        User userDto = userService.getUserByLogin(login);
        model.addAttribute("userDto", userDto);
        if (userDto == null) {
            return "redirect:/login";
        }
        return "main/mainPage";
    }
}
