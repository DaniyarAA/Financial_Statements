package kg.attractor.financial_statement.service;


import org.springframework.http.HttpHeaders;

import java.time.LocalDate;
import java.util.List;

public interface ReportService {

    HttpHeaders createHeaders(String reportType, LocalDate startDate, LocalDate endDate, String fileFormat);

    byte[] generateReport(List<Long> companyIds, LocalDate startDate, LocalDate endDate, String fileFormat);
}
