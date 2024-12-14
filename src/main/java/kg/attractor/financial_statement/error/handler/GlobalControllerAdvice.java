package kg.attractor.financial_statement.error.handler;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@ControllerAdvice
public class GlobalControllerAdvice implements ErrorController {

    @RequestMapping("/error")
    public String defaultErrorHandler(Model model, HttpServletRequest request) {
        var status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        int statusCode = Integer.parseInt(status.toString());
        String reason = HttpStatus.valueOf(statusCode).getReasonPhrase();

        model.addAttribute("status", statusCode);
        model.addAttribute("reason", reason);
        model.addAttribute("details", request);

        return "/errors/error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgumentException (Model model, HttpServletRequest request, IllegalArgumentException e) {
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("message", e.getMessage());
        model.addAttribute("details", request);
        return "/errors/error";
    }

    @ExceptionHandler(RuntimeException.class)
    public String handleInsufficientFundsException (Model model, HttpServletRequest request, RuntimeException e) {
        model.addAttribute("status", HttpStatus.PAYMENT_REQUIRED.value());
        model.addAttribute("reason", HttpStatus.PAYMENT_REQUIRED.getReasonPhrase());
        model.addAttribute("message", e.getMessage());
        model.addAttribute("details", request);
        return "/errors/error";
    }

}