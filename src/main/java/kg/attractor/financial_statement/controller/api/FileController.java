package kg.attractor.financial_statement.controller.api;

import kg.attractor.financial_statement.utils.FileUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/files")
@RequiredArgsConstructor
public class FileController {

    @GetMapping("download/{filename}")
    public ResponseEntity<?> downloadFile(@PathVariable String filename) {
        return FileUtils.downloadFile(filename);
    }
}
