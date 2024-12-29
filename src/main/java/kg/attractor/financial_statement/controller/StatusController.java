package kg.attractor.financial_statement.controller;

import kg.attractor.financial_statement.service.TaskStatusService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.security.Principal;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/status")
public class StatusController {
    private final TaskStatusService taskStatusService;

    @PostMapping("/edit")
    @ResponseBody
    public ResponseEntity<Map<String, String>> editStatus(@RequestBody Map<String, String> data, Principal principal) {
        return taskStatusService.edit(data,principal.getName());
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, String>> deleteStatus(@RequestBody Map<String, String> data, Principal principal) {
        return taskStatusService.delete(data,principal.getName());
    }
}
