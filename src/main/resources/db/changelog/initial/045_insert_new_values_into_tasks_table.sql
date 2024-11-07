--liquibase formatted sql
--changeset Adil:045

UPDATE tasks
SET is_deleted = false;
