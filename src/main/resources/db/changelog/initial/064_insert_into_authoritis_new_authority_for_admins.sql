--liquibase formatted sql
--changeset Kamilla:064

insert into authorities(authority, authority_name)
values ('VIEW_ARCHIVE', 'Просмотр всех архивов');

insert into roles_authorities(role_id, authority_id)
values ((select id from roles where role ='SuperUser'), (select id from authorities where  authority = 'VIEW_ARCHIVE'))