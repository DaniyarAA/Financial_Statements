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

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {



    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.ALWAYS))
                .formLogin(form ->
                        form.loginPage("/login")
                                .loginProcessingUrl("/login")
                                .defaultSuccessUrl("/")
                                .failureUrl("/login?error=true")
                                .permitAll())
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout")).permitAll())
                .httpBasic(withDefaults())
                .csrf(withDefaults())
                .authorizeHttpRequests(authorizeRequests -> authorizeRequests
                        .requestMatchers("/admin/**").hasAuthority("ADMIN")

//                        .requestMatchers("/tasks/**").hasAuthority("ACCOUNTANT")

                        .requestMatchers("/companies/**").authenticated()
                        .anyRequest().permitAll());
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

}
