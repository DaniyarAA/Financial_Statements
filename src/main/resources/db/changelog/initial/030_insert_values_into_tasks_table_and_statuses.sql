--liquibase formatted sql
--changeset Aktan:030
insert into task_statuses(name)
values ('Нужно сделать'),
       ('В процессе'),
       ('Готов'),
       ('Отправлен в налоговую'),
       ('На проверке'),
       ('Сдан');

update tasks
set status_id = (select id from task_statuses where name = 'Нужно сделать')
where tasks.status = 'Нужно сделать';

update tasks
set status_id = (select id from task_statuses where name = 'В процессе')
where tasks.status = 'В процессе';

update tasks
set status_id = (select id from task_statuses where name = 'Готов')
where tasks.status = 'Готов';

update tasks
set status_id = (select id from task_statuses where name = 'Отправлен в налоговую')
where tasks.status = 'Отправлен в налоговую';

update tasks
set status_id = (select id from task_statuses where name = 'На проверке')
where tasks.status = 'На проверке';

update tasks
set status_id = (select id from task_statuses where name = 'Сдан')
where tasks.status = 'Сдан';

update tasks
set "start_datetime" = to_timestamp(concat(tasks.date, ' ', tasks.time), 'YYYY-MM-DD HH24:MI:SS');

-- 161 форма: добавляем 1 месяц к дате
update tasks
set "end_datetime" = "start_datetime" + interval '1' month
where document_type_id = (select id from document_types where name = '161 форма' LIMIT 1);

-- ЕН отчет: ежеквартально, добавляем 3 месяца к дате
update tasks
set "end_datetime" = "start_datetime" + interval '3' month
where document_type_id = (select id from document_types where name = 'ЕН отчет' LIMIT 1);

-- НДС на общем режиме (Косвенный налог): ежемесячно, добавляем 1 месяц
update tasks
set "end_datetime" = "start_datetime" + interval '1' month
where document_type_id = (select id from document_types where name = 'Косвенный налог' LIMIT 1);

-- Единый налог (расчет) - ежеквартально, добавляем 3 месяца
update tasks
set "end_datetime" = "start_datetime" + interval '3' month
where document_type_id = (select id from document_types where name = 'Единый налог (расчет)' LIMIT 1);

-- Декларация расчет на прибыль - кастомно: добавляем 4 месяца
update tasks
set "end_datetime" = "start_datetime" + interval '4' month
where document_type_id = (select id from document_types where name = 'Декларация расчет на прибыль' LIMIT 1);

-- Инвест - кастомно: добавляем 2 месяца
update tasks
set "end_datetime" = "start_datetime" + interval '2 months'
where document_type_id = (select id from document_types where name = 'Инвест' LIMIT 1);

-- Импорт косв - кастомно: добавляем 2 недели
update tasks
set "end_datetime" = "start_datetime" + interval '2 weeks'
where document_type_id = (select id from document_types where name = 'Импорт косв' LIMIT 1);

-- Мусор - кастомно: добавляем 1 неделю
update tasks
set "end_datetime" = "start_datetime" + interval '7' day
where document_type_id = (select id from document_types where name = 'Мусор' LIMIT 1);

-- Статком - кастомно: добавляем 2 месяца
update tasks
set "end_datetime" = "start_datetime" + interval '2' month
where document_type_id = (select id from document_types where name = 'Статком' LIMIT 1);

-- ЭСФ - кастомно: добавляем 2 месяца
update tasks
set "end_datetime" = "start_datetime" + interval '2' month
where document_type_id = (select id from document_types where name = 'ЭСФ' LIMIT 1);

-- ЭСФ контроль - кастомно: добавляем 1 месяц и 1 неделю
update tasks
set "end_datetime" = "start_datetime" + interval '1 month' + interval '7 day'
where document_type_id = (select id from document_types where name = 'ЭСФ контроль' LIMIT 1);
