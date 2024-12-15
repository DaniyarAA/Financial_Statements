--liquibase formatted sql
--changeset Kamilla:065

ALTER TABLE tasks ALTER COLUMN start_date SET NOT NULL;
alter table tasks alter column end_date set not null;