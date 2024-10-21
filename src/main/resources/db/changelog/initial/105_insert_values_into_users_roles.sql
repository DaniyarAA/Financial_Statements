--liquibase formatted sql
--changeset Daniyar:014
INSERT INTO users_roles (user_id, role_id) VALUES
((SELECT id FROM users WHERE login = 'alexey_ivanov'), (SELECT id FROM roles WHERE role = 'ROLE_ADMIN')),
((SELECT id FROM users WHERE login = 'maria_petrova'), (SELECT id FROM roles WHERE role = 'ROLE_MANAGER')),
((SELECT id FROM users WHERE login = 'ivan_smirnov'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'ekaterina_kuznetsova'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'dmitry_popov'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'olga_sokolova'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'nikolay_lebedev'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'anna_kozlova'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'mikhail_novikov'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'elena_morozova'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'sergey_volkov'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'viktoria_zaytseva'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'alexander_sidorov'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'yulia_borisova'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'kirill_fedorov'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'anastasia_vasilyeva'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT')),
((SELECT id FROM users WHERE login = 'pavel_mikhailov'), (SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT'));