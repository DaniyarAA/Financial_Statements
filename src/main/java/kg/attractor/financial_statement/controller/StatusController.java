package kg.attractor.financial_statement.controller;

import kg.attractor.financial_statement.service.TaskStatusService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/status")
public class StatusController {
    private final TaskStatusService taskStatusService;
}
