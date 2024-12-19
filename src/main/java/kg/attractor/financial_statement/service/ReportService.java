package kg.attractor.financial_statement.service;


import org.springframework.http.HttpHeaders;

import java.time.LocalDate;
import java.util.List;

public interface ReportService {
//    HttpHeaders createHeaders(String reportType, int year, Integer month, Integer quarter, String fileFormat);
//
//    byte[] generateMonthlyReport(List<Long> companyIds, int year, int month,  String fileFormat);
//
//    byte[] generateQuarterlyReport(List<Long> companyIds, int year, int quarter,  String fileFormat);
//
//    byte[] generateYearlyReport(List<Long> companyIds, int year,  String fileFormat);

    HttpHeaders createHeaders(String reportType, LocalDate startDate, LocalDate endDate, String fileFormat);

    byte[] generateReport(List<Long> companyIds, LocalDate startDate, LocalDate endDate, String fileFormat);
}
