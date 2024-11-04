--liquibase formatted sql
--changeset Adil:043
UPDATE document_types
SET is_optional = FALSE WHERE name IN ('161 форма', 'ЕН отчет','НДС', 'НСП');

UPDATE document_types
SET is_optional = TRUE WHERE name IN ('Косвенный налог', 'Единый налог (расчет)', 'Декларация расчет на прибыль', 'Инвест', 'Импорт косв', 'Мусор', 'Статком', 'ЭСФ', 'ЭСФ контроль');
