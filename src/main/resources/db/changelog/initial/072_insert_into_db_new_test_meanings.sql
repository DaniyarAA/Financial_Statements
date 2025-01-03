--liquibase formatted sql
--changeset Kamilla:072

insert into companies(name, inn, director_inn, login, password, ecp, kabinet_salyk, kabinet_salyk_password, tax_mode, opf, district_gns, socfund_number, registration_number_mj, okpo, director, ked, email, email_password, phone, esf, esf_password, kkm, kkm_password, fresh_1c, fresh_1c_password, ettn, ettn_password, is_deleted, report_frequency)
values
    ('ОсОО "ИнфоСистемы"',326598784512,894589457845,'info_sys_login','password1','ecp_data1','salyk_cabinet1','salyk_pass1','Упрощенная','ОсОО','ГНС Первомайского района',12345601,'MJ001','12345678','Иванов Иван','KED001','info_sys@mail.com','email_pass1','+996555123001','esf_001','esf_pass1','kkm_001','kkm_pass1','1c_001','1c_pass1','ettn_001','ettn_pass1',true,null),
    ('ОсОО "Цифровой Мир"',123457890163,123456759013,'digital_world_login','password2','ecp_data2','salyk_cabinet2','salyk_pass2','Общая','ОсОО','ГНС Октябрьского района',12345602,'MJ002','12345679','Петров Петр','KED002','digital_world@mail.com','email_pass2','+996555123002','esf_002','esf_pass2','kkm_002','kkm_pass2','1c_002','1c_pass2','ettn_002','ettn_pass2',true,null),
    ('ОсОО "ВебСервис"',123457890165,123456759015,'web_service_login','password4','ecp_data4','salyk_cabinet4','salyk_pass4','Общая','ОсОО','ГНС Свердловского района',12345604,'MJ004','12345681','Кузнецов Андрей','KED004','web_service@mail.com','email_pass4','+996555123004','esf_004','esf_pass4','kkm_004','kkm_pass4','1c_004','1c_pass4','ettn_004','ettn_pass4',true,null),
    ('ОсОО "РобоТех"',123457890166,123456759016,'robo_tech_login','password5','ecp_data5','salyk_cabinet5','salyk_pass5','Упрощенная','ОсОО','ГНС Первомайского района',12345605,'MJ005','12345682','Васильев Василий','KED005','robo_tech@mail.com','email_pass5','+996555123005','esf_005','esf_pass5','kkm_005','kkm_pass5','1c_005','1c_pass5','ettn_005','ettn_pass5',true,null),
    ('ОсОО "АльфаСофтКарьера"',123457890167,123456759017,'alpha_soft_login','password6','ecp_data6','salyk_cabinet6','salyk_pass6','Общая','ОсОО','ГНС Октябрьского района',12345606,'MJ006','12345683','Алексеев Алексей','KED006','alpha_soft@mail.com','email_pass6','+996555123006','esf_006','esf_pass6','kkm_006','kkm_pass6','1c_006','1c_pass6','ettn_006','ettn_pass6',true,null),
    ('ОсОО "телевидение Мир"',123457890168,123456759018,'tech_line_login','password7','ecp_data7','salyk_cabinet7','salyk_pass7','Упрощенная','ОсОО','ГНС Ленинского района',12345607,'MJ007','12345684','Григорьев Григорий','KED007','tech_line@mail.com','email_pass7','+996555123007','esf_007','esf_pass7','kkm_007','kkm_pass7','1c_007','1c_pass7','ettn_007','ettn_pass7',true,null),
    ('ОсОО "МедиаТех"',123457890169,123456759019,'media_tech_1_login','password8','ecp_data8','salyk_cabinet8','salyk_pass8','Общая','ОсОО','ГНС Свердловского района',12345608,'MJ008','12345685','Михайлов Михаил','KED008','media_tech@mail.com','email_pass8','+996555123008','esf_008','esf_pass8','kkm_008','kkm_pass8','1c_008','1c_pass8','ettn_008','ettn_pass8',true,null),
    ('ИП "ИнновацияСофтГрупп"',123457890170,123456759020,'innovation_soft_1_login','password9','ecp_data9','salyk_cabinet9','salyk_pass9','Упрощенная','ОсОО','ГНС Первомайского района',12345609,'MJ009','12345686','Николаев Николай','KED009','innovation_soft@mail.com','email_pass9','+996555123009','esf_009','esf_pass9','kkm_009','kkm_pass9','1c_009','1c_pass9','ettn_009','ettn_pass9',true,null),
    ('ИП "ГлобалДанные"',123457890171,123456759021,'global_data_login','password10','ecp_data10','salyk_cabinet10','salyk_pass10','Общая','ОсОО','ГНС Октябрьского района',12345610,'MJ010','12345687','Смирнов Сергей','KED010','global_data@mail.com','email_pass10','+996555123010','esf_010','esf_pass10','kkm_010','kkm_pass10','1c_010','1c_pass10','ettn_010','ettn_pass10',true,null),
    ('ИП "КодФабрика"',123457890172,123456759022,'code_factory_login','password11','ecp_data11','salyk_cabinet11','salyk_pass11','Упрощенная','ОсОО','ГНС Ленинского района',12345611,'MJ011','12345688','Романов Роман','KED011','code_factory@mail.com','email_pass11','+996555123011','esf_011','esf_pass11','kkm_011','kkm_pass11','1c_011','1c_pass11','ettn_011','ettn_pass11',true,null),
    ('ИП "СофтМир"',123457890173,123456759023,'soft_world_login','password12','ecp_data12','salyk_cabinet12','salyk_pass12','Общая','ОсОО','ГНС Свердловского района',12345612,'MJ012','12345689','Федоров Федор','KED012','soft_world@mail.com','email_pass12','+996555123012','esf_012','esf_pass12','kkm_012','kkm_pass12','1c_012','1c_pass12','ettn_012','ettn_pass12',true,null),
    ('ИП "СмартСистемы"',123457890174,123456759024,'smart_systems_login','password13','ecp_data13','salyk_cabinet13','salyk_pass13','Упрощенная','ОсОО','ГНС Первомайского района',12345613,'MJ013','12345690','Тарасов Тарас','KED013','smart_systems@mail.com','email_pass13','+996555123013','esf_013','esf_pass13','kkm_013','kkm_pass13','1c_013','1c_pass13','ettn_013','ettn_pass13',true,null),
    ('ИП "ДиджиталМастер"',123457890175,123456759025,'digital_master_login','password14','ecp_data14','salyk_cabinet14','salyk_pass14','Общая','ОсОО','ГНС Октябрьского района',12345614,'MJ014','12345691','Егоров Егор','KED014','digital_master@mail.com','email_pass14','+996555123014','esf_014','esf_pass14','kkm_014','kkm_pass14','1c_014','1c_pass14','ettn_014','ettn_pass14',true,null),
    ('ИП "Решение+"',123457890176,123456759026,'solution_plus_login','password15','ecp_data15','salyk_cabinet15','salyk_pass15','Упрощенная','ОсОО','ГНС Ленинского района',12345615,'MJ015','12345692','Борисов Борис','KED015','solution_plus@mail.com','email_pass15','+996555123015','esf_015','esf_pass15','kkm_015','kkm_pass15','1c_015','1c_pass15','ettn_015','ettn_pass15',true,null),
    ('ИП "ТехЛаб"',123457890177,123456759027,'tech_lab_login','password16','ecp_data16','salyk_cabinet16','salyk_pass16','Общая','ОсОО','ГНС Свердловского района',12345616,'MJ016','12345693','Макаров Максим','KED016','tech_lab@mail.com','email_pass16','+996555123016','esf_016','esf_pass16','kkm_016','kkm_pass16','1c_016','1c_pass16','ettn_016','ettn_pass16',true,null),
    ('ИП "АйТиПрост"',123457890178,123456759028,'it_prost_login','password17','ecp_data17','salyk_cabinet17','salyk_pass17','Упрощенная','ОсОО','ГНС Первомайского района',12345617,'MJ017','12345694','Коновалов Константин','KED017','it_prost@mail.com','email_pass17','+996555123017','esf_017','esf_pass17','kkm_017','kkm_pass17','1c_017','1c_pass17','ettn_017','ettn_pass17',true,null),
    ('ИП "БайтТех"',123457890179,123456759029,'byte_tech_login','password18','ecp_data18','salyk_cabinet18','salyk_pass18','Общая','ОсОО','ГНС Октябрьского района',12345618,'MJ018','12345695','Денисов Денис','KED018','byte_tech@mail.com','email_pass18','+996555123018','esf_018','esf_pass18','kkm_018','kkm_pass18','1c_018','1c_pass18','ettn_018','ettn_pass18',true,null),
    ('ИП "МегаСофтКлуб"',123457890180,123456759030,'mega_soft_login','password19','ecp_data19','salyk_cabinet19','salyk_pass19','Упрощенная','ОсОО','ГНС Ленинского района',12345619,'MJ019','12345696','Семенов Семён','KED019','mega_soft@mail.com','email_pass19','+996555123019','esf_019','esf_pass19','kkm_019','kkm_pass19','1c_019','1c_pass19','ettn_019','ettn_pass19',true,null),
    ('ИП "ИнфоЛаборатория"',123457890181,123456759031,'info_lab_login','password20','ecp_data20','salyk_cabinet20','salyk_pass20','Общая','ОсОО','ГНС Свердловского района',12345620,'MJ020','12345697','Титов Тимофей','KED020','info_lab@mail.com','email_pass20','+996555123020','esf_020','esf_pass20','kkm_020','kkm_pass20','1c_020','1c_pass20','ettn_020','ettn_pass20',true,null),
    ('ИП "ПрограммЛайн"',123457890182,123456759032,'prog_line_login','password21','ecp_data21','salyk_cabinet21','salyk_pass21','Упрощенная','ОсОО','ГНС Первомайского района',12345621,'MJ021','12345698','Воронов Владимир','KED021','prog_line@mail.com','email_pass21','+996555123021','esf_021','esf_pass21','kkm_021','kkm_pass21','1c_021','1c_pass21','ettn_021','ettn_pass21',true,null);

insert into tasks (document_type_id, status_id, start_date, end_date, amount, description, is_deleted, time_spent, priority_id, tag_id, file_path, company_id)
values
((select id from document_types where name = 'ЕН отчет'), (select id from task_statuses where name = 'Сдан'), '2024-10-15', '2024-12-26', 3000, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Незначительная'), null, 'https://example.com/file1.pdf', (select id from companies where name = 'ОсОО "ТехноПроект"')),
((select id from document_types where name = 'ЕН отчет'), (select id from task_statuses where name = 'Сдан'), '2024-10-18', '2024-12-26', 2500, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Обычная'), null, 'https://example.com/file2.pdf', (select id from companies where name = 'ОсОО "Технопарк"')),
((select id from document_types where name = 'ЕН отчет'), (select id from task_statuses where name = 'Сдан'), '2024-11-05', '2024-12-26', 4000, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Серьезная'), null, 'https://example.com/file3.pdf', (select id from companies where name = 'ОсОО "ЭнергоПлюс"')),
((select id from document_types where name = 'ЕН отчет'), (select id from task_statuses where name = 'Готов'), '2024-10-20', '2025-01-15', null, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Критическая'), null, 'https://example.com/file4.pdf', (select id from companies where name = 'ОсОО "СтройСервис"')),
((select id from document_types where name = 'ЕН отчет'), (select id from task_statuses where name = 'В процессе'), '2024-11-10', '2025-01-20', null, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Неотложная'), null, 'https://example.com/file5.pdf', (select id from companies where name = 'ОсОО "ТрансЛогистик"')),

((select id from document_types where name = '161 форма'), (select id from task_statuses where name = 'Сдан'), '2024-10-01', '2024-12-26', 3500, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Серьезная'), null, 'https://example.com/file6.pdf', (select id from companies where name = 'ОсОО "АгроИнвест"')),
((select id from document_types where name = '161 форма'), (select id from task_statuses where name = 'Сдан'), '2024-11-01', '2024-12-26', 5000, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Серьезная'), null, 'https://example.com/file7.pdf', (select id from companies where name = 'ОсОО "АвтоДор"')),
((select id from document_types where name = '161 форма'), (select id from task_statuses where name = 'Сдан'), '2024-11-12', '2024-12-26', 4000, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Серьезная'), null, 'https://example.com/file8.pdf', (select id from companies where name = 'ОсОО "КиргизТур"')),
((select id from document_types where name = '161 форма'), (select id from task_statuses where name = 'В процессе'), '2024-10-25', '2025-01-18', null, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Серьезная'), null, 'https://example.com/file9.pdf', (select id from companies where name = 'ОсОО "МедиаПринт"')),

((select id from document_types where name = 'Мусор'), (select id from task_statuses where name = 'Сдан'), '2024-10-10', '2024-12-26', 1200, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Обычная'), null, 'https://example.com/file10.pdf', (select id from companies where name = 'ОсОО "ТехноПроект"')),
((select id from document_types where name = 'Мусор'), (select id from task_statuses where name = 'Сдан'), '2024-10-18', '2024-12-26', 1300, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Незначительная'), null, 'https://example.com/file11.pdf', (select id from companies where name = 'ОсОО "Технопарк"')),
((select id from document_types where name = 'Мусор'), (select id from task_statuses where name = 'В процессе'), '2024-11-15', '2025-01-18', null, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Критическая'), null, 'https://example.com/file12.pdf', (select id from companies where name = 'ОсОО "ЭнергоПлюс"')),

((select id from document_types where name = 'Декларация расчет на прибыль'), (select id from task_statuses where name = 'Сдан'), '2024-10-12', '2024-12-26', 3200, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Неотложная'), null, 'https://example.com/file13.pdf', (select id from companies where name = 'ОсОО "СтройСервис"')),
((select id from document_types where name = 'Декларация расчет на прибыль'), (select id from task_statuses where name = 'Готов'), '2024-11-08', '2025-01-16', null, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Серьезная'), null, 'https://example.com/file14.pdf', (select id from companies where name = 'ОсОО "ТрансЛогистик"')),
((select id from document_types where name = 'Декларация расчет на прибыль'), (select id from task_statuses where name = 'Сдан'), '2024-10-25', '2024-12-26', 4100, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Критическая'), null, 'https://example.com/file15.pdf', (select id from companies where name = 'ОсОО "АгроИнвест"')),

((select id from document_types where name = 'Инвест'), (select id from task_statuses where name = 'Сдан'), '2024-11-05', '2024-12-26', 2800, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Обычная'), null, 'https://example.com/file16.pdf', (select id from companies where name = 'ОсОО "АвтоДор"')),
((select id from document_types where name = 'Инвест'), (select id from task_statuses where name = 'Готов'), '2024-11-18', '2025-01-22', null, null, false, '2024-12-26 02:30:00',
 (select id from priorities where name = 'Неотложная'), null, 'https://example.com/file17.pdf', (select id from companies where name = 'ОсОО "КиргизТур"'));

insert into users_companies(user_id, company_id)
values
((select id from users where users.login = 'maria_petrova'), (select id from companies where companies.name = 'ОсОО "ТехноПроект"')),
((select id from users where users.login = 'maria_petrova'), (select id from companies where companies.name = 'ОсОО "Технопарк"')),
((select id from users where users.login = 'maria_petrova'), (select id from companies where companies.name = 'ОсОО "АвтоДор"')),
((select id from users where users.login = 'maria_petrova'), (select id from companies where companies.name = 'ОсОО "ЭнергоПлюс"')),
((select id from users where users.login = 'maria_petrova'), (select id from companies where companies.name = 'ОсОО "МедиаПринт"')),
((select id from users where users.login = 'maria_petrova'), (select id from companies where companies.name = 'ОсОО "АгроИнвест"')),
((select id from users where users.login = 'maria_petrova'), (select id from companies where companies.name = 'ОсОО "СтройСервис"')),

((select id from users where users.login = 'ivan_smirnov'), (select id from companies where companies.name = 'ОсОО "ТрансЛогистик"')),
((select id from users where users.login = 'ivan_smirnov'), (select id from companies where companies.name = 'ОсОО "КиргизТур"')),
((select id from users where users.login = 'ivan_smirnov'), (select id from companies where companies.name = 'ОсОО "АвтоДор"')),
((select id from users where users.login = 'ivan_smirnov'), (select id from companies where companies.name = 'ОсОО "ЭнергоПлюс"')),
((select id from users where users.login = 'ivan_smirnov'), (select id from companies where companies.name = 'ОсОО "СтройСервис"')),

((select id from users where users.login = 'ekaterina_kuznetsova'), (select id from companies where companies.name = 'ОсОО "АгроИнвест"')),
((select id from users where users.login = 'ekaterina_kuznetsova'), (select id from companies where companies.name = 'ОсОО "МедиаПринт"')),
((select id from users where users.login = 'ekaterina_kuznetsova'), (select id from companies where companies.name = 'ОсОО "КиргизТур"')),
((select id from users where users.login = 'ekaterina_kuznetsova'), (select id from companies where companies.name = 'ОсОО "Технопарк"')),

((select id from users where users.login = 'olga_sokolova'), (select id from companies where companies.name = 'ОсОО "Технопарк"')),
((select id from users where users.login = 'olga_sokolova'), (select id from companies where companies.name = 'ОсОО "ЭнергоПлюс"')),
((select id from users where users.login = 'olga_sokolova'), (select id from companies where companies.name = 'ОсОО "СтройСервис"'));

insert into users_tasks(user_id, task_id)
values
((select id from users where users.login = 'maria_petrova'),24),
((select id from users where users.login = 'maria_petrova'),16),
((select id from users where users.login = 'maria_petrova'),17),
((select id from users where users.login = 'maria_petrova'),28),
((select id from users where users.login = 'maria_petrova'),20),
((select id from users where users.login = 'maria_petrova'),22),
((select id from users where users.login = 'maria_petrova'),23 ),

((select id from users where users.login = 'ivan_smirnov'),25),
((select id from users where users.login = 'ivan_smirnov'),26),
((select id from users where users.login = 'ivan_smirnov'),27),
((select id from users where users.login = 'ivan_smirnov'),29),
((select id from users where users.login = 'ivan_smirnov'),30),

((select id from users where users.login = 'ekaterina_kuznetsova'),15),
((select id from users where users.login = 'ekaterina_kuznetsova'), 19),
((select id from users where users.login = 'ekaterina_kuznetsova'),21),
((select id from users where users.login = 'ekaterina_kuznetsova'),22),

((select id from users where users.login = 'olga_sokolova'),24),
((select id from users where users.login = 'olga_sokolova'),16),
((select id from users where users.login = 'olga_sokolova'), 17);

insert into users(name, surname, birthday, login, password, enabled, avatar, register_date, role_id, notes, credentials_updated, email)
values
    ('John', 'Smith', '1990-05-12', 'john_smith', '123', false, null, '2023-11-15', (select id from roles where role = 'Бухгалтер'), null, true, 'john.smith@example.com'),
    ('Emily', 'Johnson', '1995-02-21', 'emily_johnson', '123', false, null, '2023-11-14', (select id from roles where role = 'Бухгалтер'), null, true, 'emily.johnson@example.com'),
    ('Michael', 'Brown', '1993-07-30', 'michael_brown', '123', false, null, '2023-11-13', (select id from roles where role = 'Бухгалтер'), null, true, 'michael.brown@example.com'),
    ('Jessica', 'Taylor', '1997-11-18', 'jessica_taylor', '123', false, null, '2023-11-12', (select id from roles where role = 'Бухгалтер'), null, true, 'jessica.taylor@example.com'),
    ('William', 'Anderson', '1988-06-05', 'william_anderson', '123', false, null, '2023-11-11', (select id from roles where role = 'Бухгалтер'), null, true, 'william.anderson@example.com'),
    ('Sophia', 'Moore', '1992-12-25', 'sophia_moore', '123', false, null, '2023-11-10', (select id from roles where role = 'Бухгалтер'), null, true, 'sophia.moore@example.com'),
    ('James', 'Lee', '1985-03-17', 'james_lee', '123', false, null, '2023-11-09', (select id from roles where role = 'Бухгалтер'), null, true, 'james.lee@example.com'),
    ('Olivia', 'Martin', '1994-08-22', 'olivia_martin', '123', false, null, '2023-11-08', (select id from roles where role = 'Бухгалтер'), null, true, 'olivia.martin@example.com'),
    ('Benjamin', 'White', '1989-09-10', 'benjamin_white', '123', false, null , '2023-11-07', (select id from roles where role = 'Бухгалтер'), null, true, 'benjamin.white@example.com'),
    ('Emma', 'Harris', '1991-04-14', 'emma_harris', '123', false, null, '2023-11-06', (select id from roles where roles.role = 'Бухгалтер'), null, true, 'emma.harris@example.com'),
    ('Daniel', 'Clark', '1987-01-09', 'daniel_clark', '123', false, null, '2023-11-05', (select id from roles where role = 'Бухгалтер'), null, true, 'daniel.clark@example.com'),
    ('Isabella', 'Walker', '1996-03-20', 'isabella_walker', '123', false, null, '2023-11-04', (select id from roles where role = 'Бухгалтер'), null, true, 'isabella.walker@example.com'),
    ('Ethan', 'Young', '1983-11-11', 'ethan_young', '123', false, null, '2023-11-03', (select id from roles where role = 'Бухгалтер'), null, true, 'ethan.young@example.com'),
    ('Mia', 'Allen', '1998-10-16', 'mia_allen', '123', false, null, '2023-11-02', (select id from roles where role = 'Бухгалтер'), null, true, 'mia.allen@example.com'),
    ('Alexander', 'King', '1990-06-07', 'alexander_king', '123', false, null, '2023-11-01', (select id from roles where role = 'Бухгалтер'), null, true, 'alexander.king@example.com'),
    ('Charlotte', 'Wright', '1984-02-28', 'charlotte_wright', '123', false, null, '2023-10-31', (select id from roles where role = 'Бухгалтер'), null, true, 'charlotte.wright@example.com'),
    ('Noah', 'Scott', '1995-07-25', 'noah_scott', '123', false, null, '2023-10-30', (select id from roles where role = 'Бухгалтер'), null, true, 'noah.scott@example.com'),
    ('Amelia', 'Green', '1986-05-18', 'amelia_green', '123', false, null, '2023-10-29', (select id from roles where role = 'Бухгалтер'), null, true, 'amelia.green@example.com'),

    ('Elijah', 'Adams', '1992-09-13', 'elijah_adams', '123', false, null, '2023-10-28', (select id from roles where role = 'Бухгалтер'), null, true, 'elijah.adams@example.com'),
    ('Abigail', 'Baker', '1997-01-02', 'abigail_baker', '123', false, null, '2023-10-27', (select id from roles where role = 'Бухгалтер'), null, true, 'abigail.baker@example.com'),
    ('Aiden', 'Nelson', '1985-10-15', 'aiden_nelson', '123', false, null, '2023-10-26', (select id from roles where role = 'Бухгалтер'), null, true, 'aiden.nelson@example.com'),
    ('Harper', 'Mitchell', '1993-02-03', 'harper_mitchell', '123', false, null, '2023-10-25', (select id from roles where role = 'Бухгалтер'), null, true, 'harper.mitchell@example.com'),
    ('Logan', 'Perez', '1990-04-19', 'logan_perez', '123', false, null, '2023-10-24', (select id from roles where role = 'Бухгалтер'), null, true, 'logan.perez@example.com'),
    ('Ella', 'Roberts', '1994-08-05', 'ella_roberts', '123', false, null, '2023-10-23', (select id from roles where role = 'Бухгалтер'), null, true, 'ella.roberts@example.com'),
    ('Oliver', 'Carter', '1998-12-31', 'oliver_carter', '123', false, null, '2023-10-22', (select id from roles where role = 'Бухгалтер'), null, true, 'oliver.carter@example.com'),
    ('Liam', 'Evans', '1983-06-01', 'liam_evans', '123', false, null, '2023-10-21', (select id from roles where role = 'Бухгалтер'), null, true, 'liam.evans@example.com'),
    ('Avery', 'Turner', '1989-12-24', 'avery_turner', '123', false, null, '2023-10-20', (select id from roles where role = 'Бухгалтер'), null, true, 'avery.turner@example.com'),
    ('Lucas', 'Phillips', '1996-11-15', 'lucas_phillips', '123', false, null, '2023-10-19', (select id from roles where role = 'Бухгалтер'), null, true, 'lucas.phillips@example.com'),
    ('Grace', 'Campbell', '1984-03-26', 'grace_campbell', '123', false, null, '2023-10-18', (select id from roles where role = 'Бухгалтер'), null, true, 'grace.campbell@example.com'),
    ('Evelyn', 'Morris', '1992-03-05', 'evelyn_morris', '123', false, null, '2023-10-17', (select id from roles where role = 'Бухгалтер'), null, true, 'evelyn.morris@example.com'),
    ('Mason', 'Rodriguez', '1987-09-10', 'mason_rodriguez', '123', false, null, '2023-10-16', (select id from roles where role = 'Бухгалтер'), null, true, 'mason.rodriguez@example.com'),
    ('Lily', 'Lewis', '1995-07-18', 'lily_lewis', '123', false, null, '2023-10-15', (select id from roles where role = 'Бухгалтер'), null, true, 'lily.lewis@example.com'),
    ('Jacob', 'Walker', '1988-01-14', 'jacob_walker', '123', false, null, '2023-10-14', (select id from roles where role = 'Бухгалтер'), null, true, 'jacob.walker@example.com'),
    ('Aubrey', 'Hill', '1993-12-11', 'aubrey_hill', '123', false, null, '2023-10-13', (select id from roles where role = 'Бухгалтер'), null, true, 'aubrey.hill@example.com'),
    ('Lucas', 'Scott', '1996-06-08', 'lucas_scott', '123', false, null, '2023-10-12', (select id from roles where role = 'Бухгалтер'), null, true, 'lucas.scott@example.com'),
    ('Victoria', 'Green', '1994-02-22', 'victoria_green', '123', false, null, '2023-10-11', (select id from roles where role = 'Бухгалтер'), null, true, 'victoria.green@example.com'),
    ('Jackson', 'Adams', '1998-05-03', 'jackson_adams', '123', false, null, '2023-10-10', (select id from roles where role = 'Бухгалтер'), null, true, 'jackson.adams@example.com'),
    ('Aria', 'Mitchell', '1990-08-19', 'aria_mitchell', '123', false, null, '2023-10-09', (select id from roles where role = 'Бухгалтер'), null, true, 'aria.mitchell@example.com'),
    ('Henry', 'Perez', '1985-11-20', 'henry_perez', '123', false, null, '2023-10-08', (select id from roles where role = 'Бухгалтер'), null, true, 'henry.perez@example.com'),
    ('Scarlett', 'Cooper', '1997-09-07', 'scarlett_cooper', '123', false, null, '2023-10-07', (select id from roles where role = 'Бухгалтер'), null, true, 'scarlett.cooper@example.com'),
    ('David', 'Evans', '1989-04-25', 'david_evans', '123', false, null, '2023-10-06', (select id from roles where role = 'Бухгалтер'), null, true, 'david.evans@example.com'),
    ('Chloe', 'Bailey', '1992-10-12', 'chloe_bailey', '123', false, null, '2023-10-05', (select id from roles where role = 'Бухгалтер'), null, true, 'chloe.bailey@example.com'),
    ('Sebastian', 'Reed', '1986-06-14', 'sebastian_reed', '123', false, null, '2023-10-04', (select id from roles where role = 'Бухгалтер'), null, true, 'sebastian.reed@example.com'),
    ('Grace', 'Simmons', '1990-01-18', 'grace_simmons', '123', false, null, '2023-10-03', (select id from roles where role = 'Бухгалтер'), null, true, 'grace.simmons@example.com'),
    ('Samuel', 'Gray', '1995-03-29', 'samuel_gray', '123', false, null, '2023-10-02', (select id from roles where role = 'Бухгалтер'), null, true, 'samuel.gray@example.com'),
    ('Lillian', 'Brooks', '1987-07-01', 'lillian_brooks', '123', false, null, '2023-10-01', (select id from roles where role = 'Бухгалтер'), null, true, 'lillian.brooks@example.com'),
    ('Andrew', 'Howard', '1983-12-05', 'andrew_howard', '123', false, null, '2023-09-30', (select id from roles where role = 'Бухгалтер'), null, true, 'andrew.howard@example.com'),
    ('Ella', 'Hughes', '1996-08-13', 'ella_hughes', '123', false, null, '2023-09-29', (select id from roles where role = 'Бухгалтер'), null, true, 'ella.hughes@example.com'),
    ('Eli', 'Ross', '1994-11-26', 'eli_ross', '123', false, null, '2023-09-28', (select id from roles where role = 'Бухгалтер'), null, true, 'eli.ross@example.com');

update tasks set company_id = (select id from companies where companies.name = 'ОсОО "АвтоДор"') where id = 13;
update tasks set file_path = 'https://example.com/file1.pdf' where id = 13;
update tasks set company_id = (select id from companies where companies.name = 'ОсОО "АвтоДор"') where id = 12;
update tasks set file_path = 'https://example.com/file1.pdf' where id = 12;
update tasks set company_id = (select id from companies where companies.name = 'ОсОО "АвтоДор"') where id = 9;
update tasks set file_path = 'https://example.com/file1.pdf' where id = 9;
update tasks set company_id = (select id from companies where companies.name = 'ОсОО "АвтоДор"') where id = 8;
update tasks set file_path = 'https://example.com/file1.pdf' where id = 8;
update tasks set company_id = (select id from companies where companies.name = 'ОсОО "АвтоДор"') where id = 6;
update tasks set file_path = 'https://example.com/file1.pdf' where id = 6;

update tasks set company_id = (select id from companies where companies.name = 'ОсОО "АвтоДор"') where id = 5;
update tasks set file_path = 'https://example.com/file1.pdf' where id = 5;
update tasks set company_id = (select id from companies where companies.name = 'ОсОО "АвтоДор"') where id = 2;
update tasks set file_path = 'https://example.com/file1.pdf' where id = 2;


