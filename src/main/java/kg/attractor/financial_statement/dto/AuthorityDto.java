package kg.attractor.financial_statement.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AuthorityDto {
    private Long id;
    private String authority;
    private String authorityName;
    private boolean selected;
}
