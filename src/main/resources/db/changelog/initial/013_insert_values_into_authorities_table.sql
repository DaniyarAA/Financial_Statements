--liquibase formatted sql
--changeset Daniyar:013
INSERT INTO authorities (authority) VALUES
('VIEW_COMPANIES'),
('CREATE_COMPANIES'),
('EDIT_COMPANIES'),
('VIEW_TASKS'),
('CREATE_TASKS'),
('EDIT_TASKS'),
('VIEW_ARCHIVE'),
('VIEW_USERS'),
('CREATE_USERS'),
('EDIT_USERS');