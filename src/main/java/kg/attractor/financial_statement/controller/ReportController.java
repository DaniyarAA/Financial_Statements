package kg.attractor.financial_statement.controller;

import kg.attractor.financial_statement.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("reports")
@RequiredArgsConstructor
public class ReportController {
    private final ReportService reportService;

    @PostMapping("monthly")
    public ResponseEntity<byte[]> generateMonthlyReport(@RequestParam List<Long> companyIds,
                                                        @RequestParam String year,
                                                        @RequestParam int month) {
        int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
        byte[] reportData = reportService.generateMonthlyReportCSV(companyIds, parsedYear, month);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("text/csv"));
        headers.setContentDisposition(ContentDisposition.attachment().filename("monthly_report.csv").build());

        return new ResponseEntity<>(reportData, headers, HttpStatus.OK);
    }

    @PostMapping("quarterly")
    public ResponseEntity<byte[]> generateQuarterlyReport(@RequestParam List<Long> companyIds,
                                                          @RequestParam String year,
                                                          @RequestParam int quarter){
        int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
        byte[] reportData = reportService.generateQuarterlyReportCSV(companyIds, parsedYear, quarter);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("text/csv"));
        headers.setContentDisposition(ContentDisposition.attachment().filename("quarterly_report.csv").build());
        return new ResponseEntity<>(reportData, headers, HttpStatus.OK);
    }

    @PostMapping("yearly")
    public ResponseEntity<byte[]> generateYearlyReport(@RequestParam List<Long> companyIds,
                                                       @RequestParam String year){
        int parsedYear = Integer.parseInt(year.replaceAll(",", ""));
        byte[] reportData = reportService.generateYearlyReportCSV(companyIds, parsedYear);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("text/csv"));
        headers.setContentDisposition(ContentDisposition.attachment().filename("yearly_report.csv").build());
        return new ResponseEntity<>(reportData, headers, HttpStatus.OK);
    }
}
