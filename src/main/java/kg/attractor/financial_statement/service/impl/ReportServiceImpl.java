package kg.attractor.financial_statement.service.impl;

import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.Task;
import kg.attractor.financial_statement.repository.CompanyRepository;
import kg.attractor.financial_statement.repository.TaskRepository;
import kg.attractor.financial_statement.service.ReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReportServiceImpl implements ReportService {

    private final CompanyRepository companyRepository;
    private final TaskRepository taskRepository;


    @Override
    public byte[] generateMonthlyReportCSV(List<Long> companyIds, int year, int month) {
        LocalDate start = LocalDate.of(year, month, 1);
        LocalDate end = start.withDayOfMonth(start.lengthOfMonth());

        List<Company> companies = companyRepository.findAllById(companyIds);

        StringBuilder sb = new StringBuilder();
        sb.append("Компания;ИНН;Тип документа;Статус;Сумма;Описание;Дата сдачи\n");

        for (Company c : companies) {
            List<Task> tasks = taskRepository.findByUserCompany_Company_IdAndEndDateBetween(c.getId(), start, end);

            for (Task t : tasks) {
                String companyName = c.getName() != null ? c.getName() : "";
                String inn = c.getInn() != null ? c.getInn() : "";
                String docTypeName = t.getDocumentType() != null && t.getDocumentType().getName() != null
                        ? t.getDocumentType().getName()
                        : "";
                String statusName = t.getTaskStatus() != null && t.getTaskStatus().getName() != null
                        ? t.getTaskStatus().getName()
                        : "";
                String amount = t.getAmount() != null ? t.getAmount().toString() : "0";
                String description = t.getDescription() != null ? t.getDescription() : "";
                String endDateStr = t.getEndDate() != null ? t.getEndDate().toString() : "";

                sb.append(companyName).append(";")
                        .append(inn).append(";")
                        .append(docTypeName).append(";")
                        .append(statusName).append(";")
                        .append(amount).append(";")
                        .append(description).append(";")
                        .append(endDateStr).append("\n");
            }
        }

        return sb.toString().getBytes(StandardCharsets.UTF_8);
    }

}
