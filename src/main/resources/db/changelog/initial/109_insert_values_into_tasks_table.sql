--liquibase formatted sql
--changeset Daniyar:017
INSERT INTO tasks (status, date, time, document_type_id, user_company_id)
VALUES
    ('Не сдан', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "Технопарк"'))),

    ('Сдан', '2024-10-11', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'ЕН отчет'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ЭнергоПлюс"'))),

    ('Не сдан', '2024-10-31', '11:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "СтройСервис"'))),

    ('Не сдан', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "СтройСервис"'))),

    ('Сдан', '2024-10-11', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'ЕН отчет'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "СтройСервис"'))),

    ('Просрочен', '2024-09-30', '09:00:00',
     (SELECT id FROM document_types WHERE name = 'Статком'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "АвтоДор"'))),

    ('Сдан', '2024-09-30', '10:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "МедиаПринт"'))),

    ('Просрочен', '2024-09-30', '09:00:00',
     (SELECT id FROM document_types WHERE name = 'Статком'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ТехноПроект"'))),

    ('Сдан', '2024-10-31', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'ЭСФ'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ГрандСтрой"'))),

    ('Не сдан', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ИП "ФинЭксперт"'))),

    ('Сдан', '2024-09-30', '10:00:00',
     (SELECT id FROM document_types WHERE name = '161 форма'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "КреативТех"'))),

    ('Не сдан', '2024-10-31', '09:00:00',
     (SELECT id FROM document_types WHERE name = 'ЕН отчет'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "ТехПром"'))),

    ('Сдан', '2024-10-31', '10:00:00',
     (SELECT id FROM document_types WHERE name = 'Инвест'),
     (SELECT id FROM users_companies WHERE user_id = (SELECT id FROM users WHERE login = 'dmitry_popov') AND company_id = (SELECT id FROM companies WHERE name = 'ОсОО "АвтоТехСервис"')));