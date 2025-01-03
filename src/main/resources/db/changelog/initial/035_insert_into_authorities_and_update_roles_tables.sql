--liquibase formatted sql
--changeset Kamilla:035

update roles
set role='ROLE_ADMIN' where role = 'ADMIN';

update roles
set role='ROLE_ACCOUNTANT'
where role = 'ACCOUNTANT';

update roles set role='ROLE_MANAGER'
where role = 'MANAGER';

update roles set role='ROLE_JUNIOR_ADMIN'
where role = 'JUNIOR ADMIN';

insert into  authorities(authority)
values ('CREATE_USER'),('DELETE_USER'),('EDIT_USER'),('VIEW_USER'),
       ('CREATE_TASK'), ('DELETE_TASK'), ('EDIT_TASK'), ('VIEW_TASK'),
       ('CREATE_COMPANY'), ('DELETE_COMPANY'), ('EDIT_COMPANY'), ('VIEW_COMPANY'),
       ('CREATE_ROLE');