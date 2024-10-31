--liquibase formatted sql
--changeset Daniyar:020
INSERT INTO document_types (name) VALUES
('НДС'),
('НСП');