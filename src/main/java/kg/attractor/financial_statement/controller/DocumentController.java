package kg.attractor.financial_statement.controller;

import kg.attractor.financial_statement.service.DocumentTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/document")
public class DocumentController {
    private final DocumentTypeService documentTypeService;

    @PostMapping("/edit")
    @ResponseBody
    public ResponseEntity<Map<String, String>> editDocument(@RequestBody Map<String, String> data, Principal principal) {
        return documentTypeService.edit(data, principal.getName());
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, String>> deleteDocument(@RequestBody Map<String, String> data, Principal principal) {
        return documentTypeService.delete(data, principal.getName());
    }
}
