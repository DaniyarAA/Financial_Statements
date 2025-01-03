--liquibase formatted sql
--changeset Adil:051

UPDATE users_companies
SET is_automatic = false;
