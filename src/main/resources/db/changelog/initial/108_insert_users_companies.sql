--liquibase formatted sql
--changeset Aktan:108
insert into users_companies(user_id, company_id)
values
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "Технопарк"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ЭнергоПлюс"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "СтройСервис"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ТрансЛогистик"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "АгроИнвест"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "АвтоДор"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "МедиаПринт"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ТехноПроект"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ГрандСтрой"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ИП "ФинЭксперт"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "КреативТех"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ТехПром"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "АвтоТехСервис"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ТурСтрой"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ТелекомСервис"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ИнвестПлюс"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "ТехноТрейд"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ОсОО "СтройПромСервис"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ИП "СтройГарант"')),
        ((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM companies WHERE name = 'ИП "ТехМастер"'));