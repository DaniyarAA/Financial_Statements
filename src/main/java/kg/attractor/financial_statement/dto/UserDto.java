package kg.attractor.financial_statement.dto;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;

@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private Long id;
    private String name;
    private String surname;
    private String login;
    private String password;
    private LocalDate registrationDate;
    private boolean isActive;
  //  private String avatar;
    private boolean enabled;
    private LocalDate birthday;
    private Long roleId;
}
