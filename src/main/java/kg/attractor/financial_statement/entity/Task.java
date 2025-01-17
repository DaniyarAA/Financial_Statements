package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
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

    @ManyToOne
    @JoinColumn(name = "document_type_id")
    private DocumentType documentType;

    @ManyToOne
    @JoinColumn(name = "status_id")
    private TaskStatus taskStatus;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "amount")
    private BigDecimal amount;

    @Column(name = "description")
    private String description;

    @Column(name = "is_deleted")
    private boolean isDeleted;

    @Column(name = "time_spent")
    private LocalDateTime timeSpent;

    @Column(name = "priority_id")
    private Long priorityId;

    @Column(name = "file_path")
    private String filePath;

    @ManyToOne
    @JoinColumn(name = "tag_id", referencedColumnName = "id", foreignKey = @ForeignKey(name = "fk_tag_id_tasks"))
    private Tag tag;

    @ManyToOne
    @JoinColumn(name = "company_id")
    private Company company;

    @ManyToMany(fetch = FetchType.EAGER, mappedBy = "tasks", cascade = CascadeType.ALL)
    private List<User> users = new ArrayList<>();


}