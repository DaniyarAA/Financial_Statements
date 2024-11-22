package kg.attractor.financial_statement.error;

import lombok.experimental.StandardException;

import java.util.NoSuchElementException;

@StandardException
public class NotFoundRoleException extends NoSuchElementException {}