//package kg.attractor.financial_statement.controller.api;
//
//import kg.attractor.financial_statement.service.UserService;
//import kg.attractor.financial_statement.utils.FileUtils;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//import java.util.Map;
//
//@RestController
//@RequestMapping("api/files")
//@RequiredArgsConstructor
//public class FileController {
//    private final UserService userService;
//
//    @GetMapping("download/{filename}")
//    public ResponseEntity<?> downloadFile(@PathVariable String filename) {
//        return FileUtils.downloadFile(filename);
//    }
//    @PostMapping("upload/avatar/{userId}")
//    public ResponseEntity<?> updateUserAvatar(@PathVariable Long userId, MultipartFile file) {
//        try {
//            String resultFileName = userService.updateAvatar(userId, file);
//            return ResponseEntity.ok(Map.of("success", true, "resultFileName", resultFileName));
//        } catch (IllegalArgumentException e) {
//            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
//        }catch (IOException e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(Map.of("success", false, "message", "Internal server error"));
//        }
//
//    }
//}
