--liquibase formatted sql
--changeset Kamilla:037

update roles
set role='Админ' where role = 'ROLE_ADMIN';

update roles
set role='Бухгалтер' where role = 'ROLE_ACCOUNTANT';

update roles
set role='Менеджер' where role = 'ROLE_MANAGER';

update roles
set role='Младший админ' where role = 'ROLE_JUNIOR_ADMIN';
