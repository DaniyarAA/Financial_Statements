package kg.attractor.financial_statement.service.impl;

import com.itextpdf.io.source.ByteArrayOutputStream;
import com.itextpdf.kernel.colors.Color;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.entity.Task;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.ReportService;
import kg.attractor.financial_statement.service.TaskService;
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

    private final CompanyService companyService;
    private final TaskService taskService;


    @Override
    public byte[] generateMonthlyReportCSV(List<Long> companyIds, int year, int month){
        LocalDate startDate = LocalDate.of(year, month, 1);
        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());
        return generateReportPDF(companyIds, startDate, endDate, "Ежемесячный отчёт");
    }

    @Override
    public byte[] generateQuarterlyReportCSV(List<Long> companyIds, int year, int quarter){
        LocalDate startDate;
        LocalDate endDate = switch (quarter) {
            case 1 -> {
                startDate = LocalDate.of(year, 1, 1);
                yield LocalDate.of(year, 3, 31);
            }
            case 2 -> {
                startDate = LocalDate.of(year, 4, 1);
                yield LocalDate.of(year, 6, 30);
            }
            case 3 -> {
                startDate = LocalDate.of(year, 7, 1);
                yield LocalDate.of(year, 9, 30);
            }
            case 4 -> {
                startDate = LocalDate.of(year, 10, 1);
                yield LocalDate.of(year, 12, 31);
            }
            default -> throw new IllegalArgumentException("Неверный квартал" + quarter);
        };
        return generateReportCSV(companyIds, startDate, endDate, "Ежеквартальный отчёт");
    }

    @Override
    public byte[] generateYearlyReportCSV(List<Long> companyIds, int year){
        LocalDate startDate = LocalDate.of(year, 1, 1);
        LocalDate endDate = LocalDate.of(year, 12, 31);
        return generateReportCSV(companyIds, startDate, endDate, "Годовой отчёт");
    }


    @Override
    public byte[] generateReportCSV(List<Long> companyIds, LocalDate startDate, LocalDate endDate, String title) {
        List<Company> companies = companyService.findAllById(companyIds);

        StringBuilder sb = new StringBuilder();
        sb.append("Компания;ИНН;Тип документа;Статус;Сумма;Описание;Дата сдачи\n");

        for (Company company : companies) {
            List<Task> tasks = taskService.findByCompanyAndDate(company.getId(), startDate, endDate);

            for (Task t : tasks) {
                String companyName = company.getName() != null ? company.getName() : "";
                String inn = company.getInn() != null ? company.getInn() : "";
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


    private byte[] generateReportPDF(List<Long> companyIds, LocalDate startDate, LocalDate endDate, String reportTitle) {
        List<Company> companies = companyService.findAllById(companyIds);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(outputStream);
        PdfDocument pdfDocument = new PdfDocument(writer);
        Document document = new Document(pdfDocument);


        Paragraph title = new Paragraph(reportTitle)
                .setFontSize(9);
        document.add(title);
//        document.setFont()

        Table table = new Table(UnitValue.createPercentArray(new float[]{15,10,10,10,10,10,10})).useAllAvailableWidth();

        Color headerBackgroundColor = new DeviceRgb(255,255,255);
        Color headerTextColor = new DeviceRgb(255,255,255);
        Color evenRowColor = new DeviceRgb(230,230,230);

        table.addHeaderCell(createHeaderCell("Компания", headerBackgroundColor, headerTextColor));
        table.addHeaderCell(createHeaderCell("ИНН", headerBackgroundColor, headerTextColor));
        table.addHeaderCell(createHeaderCell("Тип документа", headerBackgroundColor, headerTextColor));
        table.addHeaderCell(createHeaderCell("Статус", headerBackgroundColor, headerTextColor));
        table.addHeaderCell(createHeaderCell("Сумма", headerBackgroundColor, headerTextColor));
        table.addHeaderCell(createHeaderCell("Описание", headerBackgroundColor, headerTextColor));
        table.addHeaderCell(createHeaderCell("Дата сдачи", headerBackgroundColor, headerTextColor));

        int rowCount = 0;
        for (Company company : companies) {
            List<Task> tasks = taskService.findByCompanyAndDate(company.getId(), startDate, endDate);
            for (Task t : tasks) {
                String companyName = company.getName() != null ? company.getName() : "";
                String inn = company.getInn() != null ? company.getInn() : "";
                String docTypeName = t.getDocumentType() != null && t.getDocumentType().getName() != null
                        ? t.getDocumentType().getName()
                        : "";
                String statusName = t.getTaskStatus() != null && t.getTaskStatus().getName() != null
                        ? t.getTaskStatus().getName()
                        : "";
                String amount = t.getAmount() != null ? t.getAmount().toString() : "0";
                String description = t.getDescription() != null ? t.getDescription() : "";
                String endDateStr = t.getEndDate() != null ? t.getEndDate().toString() : "";
                boolean evenRow = (rowCount % 2 == 0);
                table.addCell(createCell(companyName, evenRow? evenRowColor : headerTextColor));
                table.addCell(createCell(inn, evenRow? evenRowColor : headerTextColor));
                table.addCell(createCell(docTypeName, evenRow? evenRowColor : headerTextColor));
                table.addCell(createCell(statusName, evenRow? evenRowColor : headerTextColor));
                table.addCell(createCell(amount, evenRow? evenRowColor : headerTextColor));
                table.addCell(createCell(description, evenRow? evenRowColor : headerTextColor));
                table.addCell(createCell(endDateStr, evenRow? evenRowColor : headerTextColor));


                log.info("companyName: {}, inn: {}, docTypeName: {}, statusName: {}, amount: {}, description: {}, endDateStr: {}",
                        companyName, inn, docTypeName, statusName, amount, description, endDateStr);


                rowCount++;
            }
        }

        document.add(table);
        document.close();
        return outputStream.toByteArray();

    }

    private Cell createHeaderCell(String text, Color backgroundColor, Color textColor){
        Cell cell = new Cell().add(new Paragraph(text).setFontSize(10));
        cell.setBackgroundColor(backgroundColor);
        cell.setFontColor(textColor);
        cell.setTextAlignment(TextAlignment.CENTER);
        return cell;
    }

    private Cell createCell(String text, Color backgroundColor){
        Cell cell = new Cell().add(new Paragraph(text).setFontSize(10));
        cell.setFontColor(new DeviceRgb(0, 0, 0));
        cell.setBackgroundColor(backgroundColor);
        cell.setTextAlignment(TextAlignment.CENTER);
        return cell;
    }

}
