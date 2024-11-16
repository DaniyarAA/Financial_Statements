--liquibase formatted sql
--changeset Adil:046

ALTER TABLE tasks RENAME COLUMN start_datetime TO start_date;

ALTER TABLE tasks RENAME COLUMN end_datetime TO end_date;

ALTER TABLE tasks ALTER COLUMN start_date TYPE date;

ALTER TABLE tasks ALTER COLUMN end_date TYPE date;