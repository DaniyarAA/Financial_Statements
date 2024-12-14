package kg.attractor.financial_statement.service.impl;

import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.io.source.ByteArrayOutputStream;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
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
import kg.attractor.financial_statement.error.ReportGenerationException;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.ReportService;
import kg.attractor.financial_statement.service.TaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReportServiceImpl implements ReportService {

    private final CompanyService companyService;
    private final TaskService taskService;


    @Override
    public HttpHeaders createHeaders(String reportType, int year, Integer month, Integer quarter, String fileFormat) {
        String datePart;
        if (month != null){
            LocalDate date = LocalDate.of(year, month, 1);
            String monthName = date.getMonth().getDisplayName(TextStyle.FULL, Locale.of("ru"));
            datePart = String.format("%s_%d_года", monthName, year);
        } else if (quarter != null){
            datePart = String.format("%d_квартал_%d_года", quarter, year);
        } else {
            datePart = String.format("%d_год", year);
        }
        String extension = fileFormat.equalsIgnoreCase("pdf") ? "pdf" : "csv";
        String filename = String.format("%s_отчёт_%s.%s", reportType, datePart, extension);
        String encodedFilename;
        try {
            encodedFilename = URLEncoder.encode(filename, StandardCharsets.UTF_8).replace("+", "%20");
        } catch (Exception e) {
            throw new IllegalArgumentException("Ошибка кодирования имени файла: " + filename, e);
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(fileFormat.equals("pdf") ? MediaType.APPLICATION_PDF : MediaType.parseMediaType("text/csv"));
        headers.setContentDisposition(ContentDisposition.attachment().filename(encodedFilename).build());
        return headers;
    }


    @Override
    public byte[] generateMonthlyReport(List<Long> companyIds, int year, int month, String fileFormat) {
        LocalDate startDate = LocalDate.of(year, month, 1);
        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());
        if (fileFormat.equals("csv")){
            return generateReportCSV(companyIds, startDate, endDate, "Ежемесячный отчёт");
        } else {
            return generateReportPDF(companyIds, startDate, endDate, "Ежемесячный отчёт");
        }
    }

    @Override
    public byte[] generateQuarterlyReport(List<Long> companyIds, int year, int quarter, String fileFormat){
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
        if (fileFormat.equals("csv")){
            return generateReportCSV(companyIds, startDate, endDate, "Ежеквартальный отчёт");
        } else {
            return generateReportPDF(companyIds, startDate, endDate, "Ежеквартальный отчёт");
        }
    }

    @Override
    public byte[] generateYearlyReport(List<Long> companyIds, int year,  String fileFormat){
        LocalDate startDate = LocalDate.of(year, 1, 1);
        LocalDate endDate = LocalDate.of(year, 12, 31);
        if (fileFormat.equals("csv")){
            return generateReportCSV(companyIds, startDate, endDate, "Годовой отчёт");
        } else {
            return generateReportPDF(companyIds, startDate, endDate, "Годовой отчёт");
        }
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
                String description = t.getDescription() != null ? "\"" + t.getDescription() + "\"" : "";
                String endDateStr = t.getEndDate() != null ?  t.getEndDate().toString() : "";

                sb.append(companyName).append(";")
                        .append(inn).append(";")
                        .append(docTypeName).append(";")
                        .append(statusName).append(";")
                        .append(amount).append(";")
                        .append(description).append(";")
                        .append(endDateStr).append("\n");
            }
        }

        byte[] bom = new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF};
        byte[] csvFile = sb.toString().getBytes(StandardCharsets.UTF_8);

        byte[] result = new byte[csvFile.length + bom.length];
        System.arraycopy(bom, 0, result, 0, bom.length);
        System.arraycopy(csvFile, 0, result, bom.length, csvFile.length);

        return result;
    }


    private byte[] generateReportPDF(List<Long> companyIds, LocalDate startDate, LocalDate endDate, String reportTitle){
        List<Company> companies = companyService.findAllById(companyIds);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(outputStream);
        PdfDocument pdfDocument = new PdfDocument(writer);
        Document document = new Document(pdfDocument);
        String fontPath = "fonts/DejaVuSans.ttf";
        PdfFont font;
        try {
            font = PdfFontFactory.createFont(fontPath, PdfEncodings.IDENTITY_H);
        } catch (IOException e) {
            throw new ReportGenerationException("Ошибка загрузки шрифта: " + fontPath);
        }

        Paragraph title = new Paragraph(reportTitle)
                .setFontSize(6);
        document.add(title);
        document.setFont(font);

        Table table = new Table(UnitValue.createPercentArray(new float[]{27, 12, 10, 10, 10, 21, 10})).useAllAvailableWidth();


        table.addHeaderCell(createHeaderCell("Компания"));
        table.addHeaderCell(createHeaderCell("ИНН"));
        table.addHeaderCell(createHeaderCell("Тип документа"));
        table.addHeaderCell(createHeaderCell("Статус"));
        table.addHeaderCell(createHeaderCell("Сумма"));
        table.addHeaderCell(createHeaderCell("Описание"));
        table.addHeaderCell(createHeaderCell("Дата сдачи"));

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
                table.addCell(createCell(companyName));
                table.addCell(createCell(inn));
                table.addCell(createCell(docTypeName));
                table.addCell(createCell(statusName));
                table.addCell(createCell(amount));
                table.addCell(createCell(description));
                table.addCell(createCell(endDateStr));

            }
        }

        document.add(table);
        document.close();
        return outputStream.toByteArray();

    }

    private Cell createHeaderCell(String text){
        Cell cell = new Cell().add(new Paragraph(text).setFontSize(8));
        cell.setTextAlignment(TextAlignment.LEFT);
        return cell;
    }

    private Cell createCell(String text){
        Cell cell = new Cell().add(new Paragraph(text).setFontSize(8));
        cell.setFontColor(new DeviceRgb(0, 0, 0));
        cell.setTextAlignment(TextAlignment.LEFT);
        return cell;
    }

}
