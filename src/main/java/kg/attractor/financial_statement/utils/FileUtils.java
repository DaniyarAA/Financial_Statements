package kg.attractor.financial_statement.utils;

import com.ibm.icu.text.Transliterator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Slf4j
@Component
public class FileUtils {
    private static final String UPLOAD_DIR = "data/files/";

    public static ResponseEntity<?> downloadFile(String filename) {
        try {
            String originalFilename = getOriginalFilename(filename);
            Path filePath = Paths.get(UPLOAD_DIR + filename);
            if (Files.exists(filePath)) {
                Resource resource = new ByteArrayResource(Files.readAllBytes(filePath));
                String encodedFilename = URLEncoder.encode(originalFilename, StandardCharsets.UTF_8)
                        .replace("+", "%20");
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedFilename)
                        .contentLength(resource.contentLength())
                        .contentType(MediaType.APPLICATION_OCTET_STREAM)
                        .body(resource);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (IOException e) {
            log.error("Ошибка при скачивании файла: {}", filename, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    public static String getOriginalFilename(String filename) {
        int firstSpaceIndex = filename.indexOf("_");
        if (firstSpaceIndex != -1) {
            return filename.substring(firstSpaceIndex + 1);
        }
        return filename;
    }


    public static String uploadFile(MultipartFile file) throws IOException {
        String uuidFile = UUID.randomUUID().toString();
        String resultFilename = uuidFile + "_" + file.getOriginalFilename();

        Path uploadPath = Paths.get(UPLOAD_DIR);
        Files.createDirectories(uploadPath);

        Path filePath = uploadPath.resolve(resultFilename);
        try (OutputStream os = Files.newOutputStream(filePath)) {
            os.write(file.getBytes());
        }

        log.info("Файл загружен: {}", resultFilename);
        return resultFilename;
    }

    public String saveUploadedFile(MultipartFile file, String companyName) {
        String originalFileName = file.getOriginalFilename();
        if (originalFileName == null) {
            throw new RuntimeException("File name is invalid.");
        }

        String transliteratedCompanyName = convertToTransliteratedName(companyName);

        String transliteratedFileName = convertToTransliteratedName(originalFileName);

        String uploadDir = "data/files/" + transliteratedCompanyName;
        Path pathDir = Paths.get(uploadDir);

        try {
            Files.createDirectories(pathDir);
        } catch (IOException e) {
            throw new RuntimeException("Failed to create directory: " + uploadDir, e);
        }

        String uuidFile = UUID.randomUUID().toString();
        String resultFilename = uuidFile + "_" + originalFileName;

//        Path uploadPath = Paths.get(UPLOAD_DIR);
//        Files.createDirectories(uploadPath);

//        Path filePath = uploadPath.resolve(resultFilename);


//        String resolvedFileName = resolveFileName(pathDir, originalFileName);

        Path filePath = Paths.get(uploadDir);
        Path fileUploadPath = filePath.resolve(resultFilename);

        try (OutputStream os = Files.newOutputStream(fileUploadPath)) {
            os.write(file.getBytes());
        } catch (IOException e) {
            throw new RuntimeException("Failed to save file: " + originalFileName, e);
        }

        return resultFilename;
    }


    private String resolveFileName(Path directory, String fileName) {
        String baseName = fileName;
        String extension = "";

        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex != -1) {
            baseName = fileName.substring(0, dotIndex);
            extension = fileName.substring(dotIndex);
        }

        Path filePath = directory.resolve(fileName);
        int count = 1;

        while (Files.exists(filePath)) {
            fileName = baseName + " (" + count + ")" + extension;
            filePath = directory.resolve(fileName);
            count++;
        }

        return fileName;
    }

    private String convertToTransliteratedName(String inputName) {
        Transliterator transliterator = Transliterator.getInstance("Russian-Latin/BGN");
        String transliteratedName = transliterator.transliterate(inputName);

        return transliteratedName.replaceAll("[^a-zA-Z0-9-_.]", "_");
    }


    public Path getFilePath(String companyName, String fileName) {
        String transliteratedName = convertToTransliteratedName(companyName);
        return Paths.get("data", "files", transliteratedName, fileName);
    }
}
