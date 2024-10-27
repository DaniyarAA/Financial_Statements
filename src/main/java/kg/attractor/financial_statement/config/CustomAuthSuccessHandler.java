package kg.attractor.financial_statement.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomAuthSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth) throws IOException {
        String username = auth.getName();
        Cookie usernameCookie = new Cookie("username", username);
        usernameCookie.setMaxAge(30 * 24 * 60 * 60);
        usernameCookie.setPath("/");
        response.addCookie(usernameCookie);
        response.sendRedirect("/");
    }
}