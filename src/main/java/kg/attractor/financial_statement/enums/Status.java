package kg.attractor.financial_statement.enums;

import lombok.Getter;

@Getter
public enum Status {

    NEED_TO_DO("Нужно сделать"),
    IN_PROGRESS("В процессе"),
    READY("Готов"),
    SENT_TO_THE_TASK_OFFICE("Отправлен в налоговую"),
    UNDER_REVIEW("На проверке"),
    DELIVERED("Сдан");

    private final String title;
    Status(String title){
        this.title = title;
    }
}
