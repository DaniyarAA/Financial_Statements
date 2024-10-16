--liquibase formatted sql
--changeset Daniyar:015
INSERT INTO companies (name, inn, director_inn, login, password, ecp, kabinet_salyk, kabinet_salyk_password, tax_mode, opf, district_gns, socfund_number, registration_number_mj, okpo, director, ked, email, email_password, phone, esf, esf_password, kkm, kkm_password, fresh_1c, fresh_1c_password, ettn, ettn_password) VALUES
('ОсОО "Технопарк"', '123457890162', '123456759012', 'technopark_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data1', 'salyk_cabinet_tech', 'salyk_password1', 'Упрощенная', 'ОсОО', 'ГНС Первомайского района', '00123456', 'MJ123456', '567890123', 'Иванов Иван', 'KED001', 'technopark@mail.com', 'email_password1', '+996555123456', 'esf_tech', 'esf_password1', 'kkm_tech', 'kkm_password1', '1c_tech', '1c_password1', 'ettn_tech', 'ettn_password1'),
('ОсОО "ЭнергоПлюс"', '987543210948', '987654321098', 'energoplus_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data2', 'salyk_cabinet_energy', 'salyk_password2', 'Общая', 'ОсОО', 'ГНС Ленинского района', '00123457', 'MJ123457', '567890124', 'Петров Петр', 'KED002', 'energoplus@mail.com', 'email_password2', '+996555654321', 'esf_energy', 'esf_password2', 'kkm_energy', 'kkm_password2', '1c_energy', '1c_password2', 'ettn_energy', 'ettn_password2'),
('ОсОО "СтройСервис"', '134509876654', '123453987654', 'stroyservice_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data3', 'salyk_cabinet_stroy', 'salyk_password3', 'Упрощенная', 'ОсОО', 'ГНС Свердловского района', '00123458', 'MJ123458', '567890125', 'Сидоров Сидор', 'KED003', 'stroyservice@mail.com', 'email_password3', '+996555789012', 'esf_stroy', 'esf_password3', 'kkm_stroy', 'kkm_password3', '1c_stroy', '1c_password3', 'ettn_stroy', 'ettn_password3'),
('ОсОО "ТрансЛогистик"', '678901423456', '567690123456', 'translogistic_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data4', 'salyk_cabinet_trans', 'salyk_password4', 'Общая', 'ОсОО', 'ГНС Октябрьского района', '00123459', 'MJ123459', '567890126', 'Васильев Василий', 'KED004', 'translogistic@mail.com', 'email_password4', '+996555098765', 'esf_trans', 'esf_password4', 'kkm_trans', 'kkm_password4', '1c_trans', '1c_password4', 'ettn_trans', 'ettn_password4'),
('ОсОО "АгроИнвест"', '789123454678', '789012445678', 'agroinvest_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data5', 'salyk_cabinet_agro', 'salyk_password5', 'Упрощенная', 'ОсОО', 'ГНС Иссык-Кульского района', '00123460', 'MJ123460', '567890127', 'Лебедев Николай', 'KED005', 'agroinvest@mail.com', 'email_password5', '+996555345678', 'esf_agro', 'esf_password5', 'kkm_agro', 'kkm_password5', '1c_agro', '1c_password5', 'ettn_agro', 'ettn_password5'),
('ОсОО "АвтоДор"', '321097654362', '321098765532', 'avtodor_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data6', 'salyk_cabinet_avtodor', 'salyk_password6', 'Общая', 'ОсОО', 'ГНС Нарынского района', '00123461', 'MJ123461', '567890128', 'Борисов Борис', 'KED006', 'avtodor@mail.com', 'email_password6', '+996555987654', 'esf_avtodor', 'esf_password6', 'kkm_avtodor', 'kkm_password6', '1c_avtodor', '1c_password6', 'ettn_avtodor', 'ettn_password6'),
('ОсОО "КиргизТур"', '653210987645', '654320798765', 'kirgiztur_login', 'p$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data7', 'salyk_cabinet_tour', 'salyk_password7', 'Упрощенная', 'ОсОО', 'ГНС Чуйского района', '00123462', 'MJ123462', '567890129', 'Михайлов Михаил', 'KED007', 'kirgiztur@mail.com', 'email_password7', '+996555432109', 'esf_tour', 'esf_password7', 'kkm_tour', 'kkm_password7', '1c_tour', '1c_password7', 'ettn_tour', 'ettn_password7'),
('ОсОО "МедиаПринт"', '215468790162', '213556879012', 'mediaprint_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data8', 'salyk_cabinet_media', 'salyk_password8', 'Общая', 'ОсОО', 'ГНС Баткенского района', '00123463', 'MJ123463', '567890130', 'Новиков Андрей', 'KED008', 'mediaprint@mail.com', 'email_password8', '+996555567890', 'esf_media', 'esf_password8', 'kkm_media', 'kkm_password8', '1c_media', '1c_password8', 'ettn_media', 'ettn_password8'),
('ОсОО "ТехноПроект"', '980321654478', '987332165478', 'technoproject_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data9', 'salyk_cabinet_techproj', 'salyk_password9', 'Упрощенная', 'ОсОО', 'ГНС Таласского района', '00123464', 'MJ123464', '567890131', 'Кузнецов Алексей', 'KED009', 'technoproject@mail.com', 'email_password9', '+996555998877', 'esf_techproj', 'esf_password9', 'kkm_techproj', 'kkm_password9', '1c_techproj', '1c_password9', 'ettn_techproj', 'ettn_password9'),
('ОсОО "ГрандСтрой"', '3467012464385', '346770124685', 'grandstroy_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data10', 'salyk_cabinet_grand', 'salyk_password10', 'Общая', 'ОсОО', 'ГНС Каракольского района', '00123465', 'MJ123465', '567890132', 'Демидов Владимир', 'KED010', 'grandstroy@mail.com', 'email_password10', '+996555776655', 'esf_grand', 'esf_password10', 'kkm_grand', 'kkm_password10', '1c_grand', '1c_password10', 'ettn_grand', 'ettn_password10'),
('ОсОО "КараванЛогистик"', '149867065432', '1344987065432', 'karavan_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data11', 'salyk_cabinet_karavan', 'salyk_password11', 'Упрощенная', 'ОсОО', 'ГНС Ошского района', '00123466', 'MJ123466', '567890133', 'Медведев Константин', 'KED011', 'karavan@mail.com', 'email_password11', '+996555112233', 'esf_karavan', 'esf_password11', 'kkm_karavan', 'kkm_password11', '1c_karavan', '1c_password11', 'ettn_karavan', 'ettn_password11'),
('ОсОО "КреативТех"', '324786543123', '324786654123', 'creativetech_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data12', 'salyk_cabinet_creative', 'salyk_password12', 'Общая', 'ОсОО', 'ГНС Первомайского района', '00123467', 'MJ123467', '567890134', 'Калинин Игорь', 'KED012', 'creativetech@mail.com', 'email_password12', '+996555334455', 'esf_creative', 'esf_password12', 'kkm_creative', 'kkm_password12', '1c_creative', '1c_password12', 'ettn_creative', 'ettn_password12'),
('ОсОО "ТехПром"', '546213790152', '546213787012', 'techprom_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data13', 'salyk_cabinet_prom', 'salyk_password13', 'Упрощенная', 'ОсОО', 'ГНС Ленинского района', '00123468', 'MJ123468', '567890135', 'Гончаров Дмитрий', 'KED013', 'techprom@mail.com', 'email_password13', '+996555445566', 'esf_prom', 'esf_password13', 'kkm_prom', 'kkm_password13', '1c_prom', '1c_password13', 'ettn_prom', 'ettn_password13'),
('ОсОО "АвтоТехСервис"', '241568379012', '328156879012', 'avtotehservis_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data14', 'salyk_cabinet_avto', 'salyk_password14', 'Общая', 'ОсОО', 'ГНС Свердловского района', '00123469', 'MJ123469', '567890136', 'Медведев Алексей', 'KED014', 'avtotehservis@mail.com', 'email_password14', '+996555556677', 'esf_avto', 'esf_password14', 'kkm_avto', 'kkm_password14', '1c_avto', '1c_password14', 'ettn_avto', 'ettn_password14'),
('ОсОО "ТурСтрой"', '765480123425', '765489019345', 'turstroy_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data15', 'salyk_cabinet_tur', 'salyk_password15', 'Упрощенная', 'ОсОО', 'ГНС Октябрьского района', '00123470', 'MJ123470', '567890137', 'Ларионов Виктор', 'KED015', 'turstroy@mail.com', 'email_password15', '+996555667788', 'esf_tur', 'esf_password15', 'kkm_tur', 'kkm_password15', '1c_tur', '1c_password15', 'ettn_tur', 'ettn_password15'),
('ОсОО "ТелекомСервис"', '134987635432', '12339765432', 'telecom_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data16', 'salyk_cabinet_telecom', 'salyk_password16', 'Общая', 'ОсОО', 'ГНС Иссык-Кульского района', '00123471', 'MJ123471', '567890138', 'Романов Роман', 'KED016', 'telecom@mail.com', 'email_password16', '+996555778899', 'esf_telecom', 'esf_password16', 'kkm_telecom', 'kkm_password16', '1c_telecom', '1c_password16', 'ettn_telecom', 'ettn_password16'),
('ОсОО "ИнвестПлюс"', '219765432130', '219876564210', 'investplus_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data17', 'salyk_cabinet_invest', 'salyk_password17', 'Упрощенная', 'ОсОО', 'ГНС Нарынского района', '00123472', 'MJ123472', '567890139', 'Беляков Сергей', 'KED017', 'investplus@mail.com', 'email_password17', '+996555889900', 'esf_invest', 'esf_password17', 'kkm_invest', 'kkm_password17', '1c_invest', '1c_password17', 'ettn_invest', 'ettn_password17'),
('ОсОО "ТехноТрейд"', '542109876454', '543210983654', 'technotrade_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data18', 'salyk_cabinet_technotrade', 'salyk_password18', 'Общая', 'ОсОО', 'ГНС Чуйского района', '00123473', 'MJ123473', '567890140', 'Зайцев Николай', 'KED018', 'technotrade@mail.com', 'email_password18', '+996555990011', 'esf_technotrade', 'esf_password18', 'kkm_technotrade', 'kkm_password18', '1c_technotrade', '1c_password18', 'ettn_technotrade', 'ettn_password18'),
('ОсОО "СтройПромСервис"', '124566780123', '12376780123', 'stroyserv_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data19', 'salyk_cabinet_stroyserv', 'salyk_password19', 'Упрощенная', 'ОсОО', 'ГНС Баткенского района', '00123474', 'MJ123474', '567890141', 'Миронов Дмитрий', 'KED019', 'stroyserv@mail.com', 'email_password19', '+996555101112', 'esf_stroyserv', 'esf_password19', 'kkm_stroyserv', 'kkm_password19', '1c_stroyserv', '1c_password19', 'ettn_stroyserv', 'ettn_password19'),
('ИП "СтройГарант"', '987654310412', '987654321412', 'stroygarant_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data20', 'salyk_cabinet_stroygarant', 'salyk_password20', 'Упрощенная', 'ИП', 'ГНС Таласского района', '00123475', 'MJ123475', '432573454','Семенов Олег', 'KED020', 'stroygarant@mail.com', 'email_password20', '+996555202122', 'esf_stroygarant', 'esf_password20', 'kkm_stroygarant', 'kkm_password20', '1c_stroygarant', '1c_password20', 'ettn_stroygarant', 'ettn_password20'),
('ИП "ТехМастер"', '876543211233', '876543210143', 'techmaster_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data21', 'salyk_cabinet_techmaster', 'salyk_password21', 'Упрощенная', 'ИП', 'ГНС Каракольского района', '00123476', 'MJ123476','5723857236' ,'Иванов Петр', 'KED021', 'techmaster@mail.com', 'email_password21', '+996555303132', 'esf_techmaster', 'esf_password21', 'kkm_techmaster', 'kkm_password21', '1c_techmaster', '1c_password21', 'ettn_techmaster', 'ettn_password21'),
('ИП "АвтоЛидер"', '765432098766', '765432109376', 'autoleader_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data22', 'salyk_cabinet_autoleader', 'salyk_password22', 'Упрощенная', 'ИП', 'ГНС Ошского района', '00123477', 'MJ123477', '578347934','Васильев Антон', 'KED022', 'autoleader@mail.com', 'email_password22', '+996555404142', 'esf_autoleader', 'esf_password22', 'kkm_autoleader', 'kkm_password22', '1c_autoleader', '1c_password22', 'ettn_autoleader', 'ettn_password22'),
('ИП "ЛогистПлюс"', '654210987465', '654321099765', 'logistplus_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data23', 'salyk_cabinet_logistplus', 'salyk_password23', 'Упрощенная', 'ИП', 'ГНС Первомайского района', '00123478', 'MJ123478', '573563477','Борисов Виктор', 'KED023', 'logistplus@mail.com', 'email_password23', '+996555505152', 'esf_logistplus', 'esf_password23', 'kkm_logistplus', 'kkm_password23', '1c_logistplus', '1c_password23', 'ettn_logistplus', 'ettn_password23'),
('ИП "СервисПро"', '543109876254', '543210987254', 'servicepro_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data24', 'salyk_cabinet_servicepro', 'salyk_password24', 'Упрощенная', 'ИП', 'ГНС Свердловского района', '00123479', 'MJ123479', '75575438','Козлов Сергей', 'KED024', 'servicepro@mail.com', 'email_password24', '+996555606162', 'esf_servicepro', 'esf_password24', 'kkm_servicepro', 'kkm_password24', '1c_servicepro', '1c_password24', 'ettn_servicepro', 'ettn_password24'),
('ИП "ТуристГид"', '432108765443', '432109873543', 'turistgid_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data25', 'salyk_cabinet_turistgid', 'salyk_password25', 'Упрощенная', 'ИП', 'ГНС Октябрьского района', '00123480', 'MJ123480', '85934850','Захаров Андрей', 'KED025', 'turistgid@mail.com', 'email_password25', '+996555707172', 'esf_turistgid', 'esf_password25', 'kkm_turistgid', 'kkm_password25', '1c_turistgid', '1c_password25', 'ettn_turistgid', 'ettn_password25'),
('ИП "БизнесЛидер"', '321097675432', '321097765432', 'bizleader_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data26', 'salyk_cabinet_bizleader', 'salyk_password26', 'Упрощенная', 'ИП', 'ГНС Иссык-Кульского района', '00123481', 'MJ123481', '79543859','Егоров Михаил', 'KED026', 'bizleader@mail.com', 'email_password26', '+996555808182', 'esf_bizleader', 'esf_password26', 'kkm_bizleader', 'kkm_password26', '1c_bizleader', '1c_password26', 'ettn_bizleader', 'ettn_password26'),
('ИП "ФинЭксперт"', '210976554321', '210987954321', 'finexpert_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data27', 'salyk_cabinet_finexpert', 'salyk_password27', 'Упрощенная', 'ИП', 'ГНС Нарынского района', '00123482', 'MJ123482', '89347675','Федоров Дмитрий', 'KED027', 'finexpert@mail.com', 'email_password27', '+996555909192', 'esf_finexpert', 'esf_password27', 'kkm_finexpert', 'kkm_password27', '1c_finexpert', '1c_password27', 'ettn_finexpert', 'ettn_password27'),
('ИП "СельХозТех"', '098764232109', '098765032109', 'selhoztech_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data28', 'salyk_cabinet_selhoztech', 'salyk_password28', 'Упрощенная', 'ИП', 'ГНС Чуйского района', '00123483', 'MJ123483', '58349534','Алексеев Олег', 'KED028', 'selhoztech@mail.com', 'email_password28', '+996555101112', 'esf_selhoztech', 'esf_password28', 'kkm_selhoztech', 'kkm_password28', '1c_selhoztech', '1c_password28', 'ettn_selhoztech', 'ettn_password28'),
('ИП "МегаСтрой"', '109875343210', '109876533210', 'megastroy_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data29', 'salyk_cabinet_megastroy', 'salyk_password29', 'Упрощенная', 'ИП', 'ГНС Октябрьского района', '00123484', 'MJ123484', '57238957','Сидоров Максим', 'KED029', 'megastroy@mail.com', 'email_password29', '+996555202122', 'esf_megastroy', 'esf_password29', 'kkm_megastroy', 'kkm_password29', '1c_megastroy', '1c_password29', 'ettn_megastroy', 'ettn_password29'),
('ИП "ПроИнвест"', '987546321098', '987654301098', 'proinvest_login', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', 'ecp_data30', 'salyk_cabinet_proinvest', 'salyk_password30', 'Упрощенная', 'ИП', 'ГНС Каракольского района', '00123485', 'MJ123485', '5728935','Громов Владимир', 'KED030', 'proinvest@mail.com', 'email_password30', '+996555303132', 'esf_proinvest', 'esf_password30', 'kkm_proinvest', 'kkm_password30', '1c_proinvest', '1c_password30', 'ettn_proinvest', 'ettn_password30');