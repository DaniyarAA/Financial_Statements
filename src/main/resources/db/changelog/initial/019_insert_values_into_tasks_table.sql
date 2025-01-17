--liquibase formatted sql
--changeset Daniyar:019
INSERT INTO tasks (status, date, time, document_type_id, user_company_id)
VALUES
    ('Нужно сделать', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "Технопарк"'))),

    ('В процессе', '2024-10-11', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'ЕН отчет'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ЭнергоПлюс"'))),

    ('Готов', '2024-10-31', '11:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "СтройСервис"'))),

    ('В процессе', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "СтройСервис"'))),

    ('Отправлен в налоговую', '2024-10-11', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'ЕН отчет'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "СтройСервис"'))),

    ('На проверке', '2024-09-30', '09:00:00',
     (SELECT id FROM document_types WHERE name = 'Статком'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "АвтоДор"'))),

    ('На проверке', '2024-09-30', '10:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "МедиаПринт"'))),

    ('Нужно сделать', '2024-09-30', '09:00:00',
     (SELECT id FROM document_types WHERE name = 'Статком'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ТехноПроект"'))),

    ('Готов', '2024-10-31', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'ЭСФ'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ГрандСтрой"'))),

    ('Готов', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ИП "ФинЭксперт"'))),

    ('Сдан', '2024-09-30', '10:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "КреативТех"'))),

    ('В процессе', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = 'ЕН отчет'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ТехПром"'))),

    ('Сдан', '2024-10-31', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'Инвест'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "АвтоТехСервис"')));