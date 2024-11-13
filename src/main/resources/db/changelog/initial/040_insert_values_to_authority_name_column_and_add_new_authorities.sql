--liquibase formatted sql
--changeset Kamilla:040

insert into authorities(authority) values ('EDIT_ROLE'), ('DELETE_ROLE'), ('VIEW_ROLES');

update authorities
set authority_name = 'Зарегестрировать пользователя'
where authority = 'CREATE_USER';

update authorities
set authority_name = 'Удалить пользователя'
where authority = 'DELETE_USER';
update authorities
set authority_name = 'Изменить параметры пользователя'
where authority = 'EDIT_USER';
update authorities
set authority_name = 'Просмотеть данные о пользователе'
where authority = 'VIEW_USER';
update authorities
set authority_name = 'Создание задачи'
where authority = 'CREATE_TASK';
update authorities
set authority_name = 'Удаление задачи'
where authority = 'DELETE_TASK';
update authorities
set authority_name = 'Изменение данных задачи'
where authority = 'EDIT_TASK';
update authorities
set authority_name = 'Просмотерть задачи'
where authority = 'VIEW_TASK';
update authorities
set authority_name = 'Создание компании'
where authority = 'CREATE_COMPANY';
update authorities
set authority_name = 'Удаление компании'
where authority = 'DELETE_COMPANY';
update authorities
set authority_name = 'Изменение данных компании'
where authority = 'EDIT_COMPANY';
update authorities
set authority_name = 'Просмотр компаний'
where authority = 'VIEW_COMPANY';
update authorities
set authority_name = 'Создание роли'
where authority = 'CREATE_ROLE';

update authorities
set authority_name = 'Изменение параметров для роли'
where authority = 'EDIT_ROLE';

update authorities
set authority_name = 'Удаление роли'
where authority = 'DELETE_ROLE';

update authorities
set authority_name = 'Просмотр списка ролей'
where authority = 'VIEW_ROLES';
