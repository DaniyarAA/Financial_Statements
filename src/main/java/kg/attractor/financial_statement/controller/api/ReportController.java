package kg.attractor.financial_statement.controller.api;

import kg.attractor.financial_statement.error.ReportGenerationException;
import kg.attractor.financial_statement.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/reports")
@RequiredArgsConstructor
public class ReportController {
    private final ReportService reportService;

    @PostMapping("monthly/csv")
    public ResponseEntity<?> generateMonthlyReportCSV(@RequestParam List<Long> companyIds,
                                                        @RequestParam String year,
                                                        @RequestParam int month) {
        try {
            int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
            byte[] reportData = reportService.generateMonthlyReport(companyIds, parsedYear, month, "csv");
            HttpHeaders headers = reportService.createHeaders("Ежемесячный", parsedYear, month, null, "csv");
            return new ResponseEntity<>(reportData, headers, HttpStatus.OK);
        } catch (IllegalArgumentException e){
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));

        }

    }

    @PostMapping("quarterly/csv")
    public ResponseEntity<?> generateQuarterlyReportCSV(@RequestParam List<Long> companyIds,
                                                          @RequestParam String year,
                                                          @RequestParam int quarter){
        try{
            int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
            byte[] reportData = reportService.generateQuarterlyReport(companyIds, parsedYear, quarter, "csv");
            HttpHeaders headers = reportService.createHeaders("Ежеквартальный", parsedYear, null, quarter, "csv");
            return new ResponseEntity<>(reportData, headers, HttpStatus.OK);
        } catch (IllegalArgumentException e){
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));

        }
    }


    @PostMapping("yearly/csv")
    public ResponseEntity<?> generateYearlyReportCSV(@RequestParam List<Long> companyIds,
                                                       @RequestParam String year){
        try {
            int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
            byte[] reportData = reportService.generateYearlyReport(companyIds, parsedYear, "csv");
            HttpHeaders headers = reportService.createHeaders("Годовой", parsedYear, null, null, "csv");
            return new ResponseEntity<>(reportData, headers, HttpStatus.OK);
        } catch (IllegalArgumentException e){
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));

        }

    }

    @PostMapping("monthly/pdf")
    public ResponseEntity<?> generateMonthlyReportPDF(@RequestParam List<Long> companyIds,
                                                           @RequestParam String year,
                                                           @RequestParam int month){
        try {
            int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
            byte[] pdfData = reportService.generateMonthlyReport(companyIds, parsedYear, month, "pdf");
            HttpHeaders headers = reportService.createHeaders("Ежемесячный", parsedYear, month, null, "pdf");
            return new ResponseEntity<>(pdfData, headers, HttpStatus.OK);
        } catch (ReportGenerationException | IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }

    }

    @PostMapping("quarterly/pdf")
    public ResponseEntity<?> generateQuarterlyReportPDF(@RequestParam List<Long> companyIds,
                                                      @RequestParam String year,
                                                      @RequestParam int quarter){
        try {
            int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
            byte[] pdfData = reportService.generateQuarterlyReport(companyIds, parsedYear, quarter, "pdf");
            HttpHeaders headers = reportService.createHeaders("Квартальный", parsedYear, null, quarter, "pdf");
            return new ResponseEntity<>(pdfData, headers, HttpStatus.OK);
        } catch (ReportGenerationException | IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }

    }

    @PostMapping("yearly/pdf")
    public ResponseEntity<?> generateYearlyReportPDF(@RequestParam List<Long> companyIds,
                                                      @RequestParam String year){
        try {
            int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
            byte[] pdfData = reportService.generateYearlyReport(companyIds, parsedYear,"pdf");
            HttpHeaders headers = reportService.createHeaders("Годовой", parsedYear, null, null, "pdf");
            return new ResponseEntity<>(pdfData, headers, HttpStatus.OK);
        } catch (ReportGenerationException | IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }

    }
}

