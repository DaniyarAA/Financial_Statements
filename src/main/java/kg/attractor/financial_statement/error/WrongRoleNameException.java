package kg.attractor.financial_statement.error;

public class WrongRoleNameException extends RuntimeException {
    public WrongRoleNameException(String message) {
        super(message);
    }
}
