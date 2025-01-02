package kg.attractor.financial_statement.enums;

import lombok.Getter;

@Getter
public enum Document {

    EN_REPORT("ЕН отчет"),
    NDS("НДС"),
    NSP("НСП"),
    FORM_161("161 форма"),
    INDIRECT_TAX("Косвенный налог"),
    SINGE_TAX_CALCULATION("Единый налог (расчет)"),
    DECLARATION_OF_PROFIT_CALCULATION("Декларация расчет на прибыль"),
    INVEST("Инвест"),
    IMPORT_COSW("Импорт косв"),
    GARBAGE("Мусор"),
    STATCOM("Статком"),
    ESF("ЭСФ"),
    ESF_CONTROL("ЭСФ контроль");


    private String title;
    Document(String title) {
        this.title = title;
    }
}
