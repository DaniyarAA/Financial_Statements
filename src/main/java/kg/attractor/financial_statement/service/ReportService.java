package kg.attractor.financial_statement.service;

import java.time.LocalDate;
import java.util.List;

public interface ReportService {
    byte[] generateMonthlyReportCSV(List<Long> companyIds, int year, int month);

    byte[] generateQuarterlyReportCSV(List<Long> companyIds, int year, int quarter);

    byte[] generateYearlyReportCSV(List<Long> companyIds, int year);

    byte[] generateReportCSV(List<Long> companyIds, LocalDate startDate, LocalDate endDate, String title);
}
