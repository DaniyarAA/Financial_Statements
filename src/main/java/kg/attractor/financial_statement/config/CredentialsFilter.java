package kg.attractor.financial_statement.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kg.attractor.financial_statement.dto.UserDto;
import kg.attractor.financial_statement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component

public class CredentialsFilter extends OncePerRequestFilter {

    private final UserService userService;

    @Autowired
    public CredentialsFilter(@Lazy UserService userService) {
        this.userService = userService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String requestURI = request.getRequestURI();

        if (requestURI.startsWith("/css/") || requestURI.startsWith("/js/") || requestURI.startsWith("/images/")) {
            filterChain.doFilter(request, response);
            return;
        }

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.isAuthenticated()
            && authentication.getPrincipal() instanceof UserDetails) {

            UserDto userDto = userService.getUserDtoByLogin(authentication.getName());

            if (userDto != null && !userDto.isCredentialsUpdated() && !requestURI.equals("/change-credentials")) {
                response.sendRedirect("/change-credentials");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }
}