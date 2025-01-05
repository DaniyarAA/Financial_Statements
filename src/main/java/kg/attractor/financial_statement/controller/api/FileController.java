package kg.attractor.financial_statement.controller.api;

import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.TaskService;
import kg.attractor.financial_statement.service.UserService;
import kg.attractor.financial_statement.utils.FileUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.core.io.Resource;


import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Path;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("api/files")
@RequiredArgsConstructor
public class FileController {
    private final UserService userService;
    private final CompanyService companyService;
    private final TaskService taskService;

    @GetMapping("download/{filename}")
    public ResponseEntity<?> downloadFile(@PathVariable String filename) {
        return FileUtils.downloadFile(filename);
    }

    @GetMapping("download/{companyId}/{fileName}")
    public ResponseEntity<Resource> downloadFileFromTaskList (
            @PathVariable Long companyId,
            @PathVariable String fileName
    ) throws MalformedURLException {
        System.out.println("CompanyId: " + companyId);
        System.out.println("FileName: " + fileName);
        try {
            String companyName = companyService.getCompanyNameById(companyId);

            Optional<Path> filePathOptional = taskService.getFilePath(companyName, fileName);

            if (filePathOptional.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
            Path filePath = filePathOptional.get();
            Resource resource = taskService.loadFileAsResource(filePath);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filePath.getFileName().toString() + "\"")
                    .body(resource);
        } catch (MalformedURLException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("upload/avatar/{userId}")
    public ResponseEntity<?> updateUserAvatar(@PathVariable Long userId, MultipartFile file) {
        try {
            String resultFileName = userService.updateAvatar(userId, file);
            return ResponseEntity.ok(Map.of("success", true, "resultFileName", resultFileName));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }

    }
}
