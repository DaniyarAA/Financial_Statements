--liquibase formatted sql
--changeset Daniyar:011
INSERT INTO roles (role) VALUES
('ROLE_ADMIN'),
('ROLE_ACCOUNTANT'),
('ROLE_MANAGER');