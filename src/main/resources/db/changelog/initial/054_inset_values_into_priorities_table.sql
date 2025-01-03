--liquibase formatted sql
--changeset Adil:054

insert into priorities(name)
values ('Незначительная'),
       ('Обычная'),
       ('Серьезная'),
       ('Неотложная'),
       ('Критическая');