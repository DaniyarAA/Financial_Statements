package kg.attractor.financial_statement.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.entity.User;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

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

    @GetMapping("/change-credentials")
    public String changeCredentialsPage(Model model, Principal principal) {
        User user = userService.getUserByLogin(principal.getName());
        model.addAttribute("userId", user.getId());
        return "auth/change-credentials";
    }

    @PostMapping("/change-credentials")
    public ResponseEntity<?> changeCredentials(@RequestBody Map<String, String> loginAndPassword, Authentication auth,
                                               HttpServletRequest request,
                                               HttpServletResponse response) {
        User user = userService.getUserByLogin(auth.getName());
        try {
            String newUsername = loginAndPassword.get("newUsername");
            String newPassword = loginAndPassword.get("newPassword");
            userService.updateLoginAndPassword(user.getId(), newUsername, newPassword);
            request.getSession().invalidate();
            Cookie usernameCookie = new Cookie("username", null);
            usernameCookie.setMaxAge(0);
            usernameCookie.setPath("/");
            response.addCookie(usernameCookie);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }
}