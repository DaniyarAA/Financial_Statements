package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasks")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime from;
    private LocalDateTime to;

    @ManyToOne
    @JoinColumn(name = "document_type_id")
    private DocumentType documentType;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "task")
    private List<Report> reports;

    @ManyToOne
    @JoinColumn(name = "user_company_id", referencedColumnName = "id")
    private UserCompany userCompany;

    @ManyToOne
    @JoinColumn(name = "status_id")
    private TaskStatus taskStatus;

}
