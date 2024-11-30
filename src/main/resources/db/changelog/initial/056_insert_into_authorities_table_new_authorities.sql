--liquibase formatted sql
--changeset Kamilla:056
insert into authorities(authority, authority_name)
values ('CREATE_STATUS', 'Создать новый статус для задач'),
       ('EDIT_STATUS', 'Изменить название статуса'),
       ('DELETE_STATUS','Удалить статус для задач'),
       ('VIEW_STATUS', 'Просмотреть статусы задач'),
       ('CREATE_DOCUMENT', 'Создать новый вид документа'),
       ('EDIT_DOCUMENT', 'Изменить название документа'),
       ('DELETE_DOCUMENT', 'Удалить вид документа'),
       ('VIEW_DOCUMENT', 'Просмотреть виды документов');

insert into roles_authorities(role_id, authority_id)
values((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'VIEW_TASK')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'CREATE_STATUS')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'EDIT_STATUS')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'DELETE_STATUS')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'VIEW_STATUS')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'CREATE_DOCUMENT')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'VIEW_DOCUMENT')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'EDIT_DOCUMENT')),
      ((SELECT id FROM roles WHERE role = 'SuperUser'),(select id from authorities where authority = 'DELETE_DOCUMENT'));

