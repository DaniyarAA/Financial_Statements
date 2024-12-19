package kg.attractor.financial_statement.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tags")
public class Tag {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tag")
    private String tag;

    @OneToMany(mappedBy = "tag")
    private List<Task> tasks;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
