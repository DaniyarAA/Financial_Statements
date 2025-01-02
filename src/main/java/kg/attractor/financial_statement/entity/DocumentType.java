package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "document_types")
public class DocumentType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(name = "is_optional")
    private boolean isOptional;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "documentType")
    private List<Task> tasks;
}
