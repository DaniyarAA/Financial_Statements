package kg.attractor.financial_statement.controller;

import kg.attractor.financial_statement.service.DocumentTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/document")
public class DocumentController {
    private final DocumentTypeService documentTypeService;
}
