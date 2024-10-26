package kg.attractor.financial_statement.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final CustomAuthSuccessHandler authSuccessHandler;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.ALWAYS))
                .httpBasic(Customizer.withDefaults())
                .formLogin(form ->
                        form.loginPage("/auth/login")
                                .loginProcessingUrl("/auth/login")
                                .successHandler(authSuccessHandler)
                                .failureUrl("/auth/login?error=true")
                                .permitAll())
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout")).permitAll())
                .authorizeHttpRequests(authorizeRequests -> authorizeRequests
                        .requestMatchers("/admin/create/role").hasAuthority("CREATE_ROLE")
                        .requestMatchers("/admin/users").hasAuthority("VIEW_USER")
                        .requestMatchers("/admin/register").hasAuthority("CREATE_USER")
                        .requestMatchers("/admin/user/edit/").hasAuthority("EDIT_USER")

                        .requestMatchers("/company/all").hasAuthority("VIEW_COMPANY")
                        .requestMatchers("/company/create").hasAuthority("CREATE_COMPANY")
                        .requestMatchers("/company/edit/").hasAuthority("EDIT_COMPANY")
                        .requestMatchers("/company/delete").hasAuthority("DELETE_COMPANY")

                        .anyRequest().permitAll());
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

}
