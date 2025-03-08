--liquibase formatted sql
--changeset Kamilla:074

insert into authorities(authority, authority_name)
values ('VIEW_SENSITIVE_DATA', 'Просмотр чувствительных данных');

insert into roles_authorities(role_id, authority_id)
values ((select id from roles where role ='SuperUser'), (select id from authorities where  authority = 'VIEW_SENSITIVE_DATA'))