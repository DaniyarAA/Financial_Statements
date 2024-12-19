package kg.attractor.financial_statement.service.impl;


import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import kg.attractor.financial_statement.dto.UserDto;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;

@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String EMAIL_FROM;

    public void sendMail(String email, String login , String adminText,String password , String link ,String userName) throws MessagingException, UnsupportedEncodingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message);

        helper.setFrom(EMAIL_FROM, "Администрация финансовых отчетов");
        helper.setTo(email);

        String subject = "Данные о вашем аккаунте для входа в программу финансовых отчетов";
        String body = "<p>Здраствуйте, " + userName + " !</p>"
                + "<p>Ваш логин для входа в систему: " + login + " </p>"
                + "<p>Ваш пароль для входа в систему: " + password + " </p>"
                + "<p><a href=\"" + link + "\" target=\"_blank\" rel=\"noopener noreferrer\">Войти в аккаунт</a></p>"
                + "<br>"
                + "<p>" + adminText + "</p>";

        helper.setSubject(subject);
        helper.setText(body, true);

        mailSender.send(message);
    }
}
