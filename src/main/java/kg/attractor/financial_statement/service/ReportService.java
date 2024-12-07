package kg.attractor.financial_statement.service;

import java.util.List;

public interface ReportService {
    byte[] generateMonthlyReportCSV(List<Long> companyIds, int year, int month);
}
