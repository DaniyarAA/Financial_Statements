--liquibase formatted sql
--changeset Kamilla:04

update roles
set role = 'SuperUser'
where roles.role = 'Админ';
update roles
set role = 'Админ'
where roles.role = 'Младший админ';

update authorities
set authority_name='Зарегистрировать пользователя'
where authority='CREATE_USER';

update authorities
set authority_name='Просмотреть данные о пользователе'
where authority='VIEW_USER';

update authorities
set authority_name = 'Просмотреть задачи'
where authority='VIEW_TASK';

insert into roles_authorities(role_id, authority_id)
values ((select id from roles where role = 'SuperUser'),(select id from authorities where authority = 'CREATE_TASK')),
       ((select id from roles where role = 'SuperUser'),(select id from authorities where authority = 'DELETE_TASK')),
       ((select id from roles where role = 'SuperUser'),(select id from authorities where authority = 'EDIT_TASK')),
       ((select id from roles where role = 'SuperUser'),(select id from authorities where authority = 'EDIT_ROLE')),
       ((select id from roles where role = 'SuperUser'),(select id from authorities where authority = 'DELETE_ROLE')),
       ((select id from roles where role = 'SuperUser'),(select id from authorities where authority = 'VIEW_ROLES'));
