package kg.attractor.financial_statement.enums;

import lombok.Getter;

@Getter
public enum TaskPriority {
    LOW(1, "#5b5b5b"),
    NORMAL(2, "#90ee90"),
    SERIOUS(3, "#ffcc00"),
    URGENT(4, "#ff4d4d"),
    CRITICAL(5, "#ff80ff");

    private final int id;
    private final String color;

    TaskPriority(int id, String color) {
        this.id = id;
        this.color = color;
    }

    public static String getColorByIdOrDefault(Integer id) {
        if (id == null) {
            return "#bdbdbd";
        }
        for (TaskPriority priority : values()) {
            if (priority.getId() == id) {
                return priority.getColor();
            }
        }
        return "#bdbdbd";
    }
}