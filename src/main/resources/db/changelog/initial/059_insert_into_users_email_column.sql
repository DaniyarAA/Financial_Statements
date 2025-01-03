--liquibase formatted sql
--changeset Kamilla:059

update users set email  = 'admin@gmail.com' where login = 'admin';
update users set email  = 'maria_petrova@gmail.com' where login = 'maria_petrova';
update users set email  = 'ivan_smirnov@gmail.com' where login = 'ivan_smirnov';
update users set email  = 'ekaterina_kuznetsova@gmail.com' where login = 'ekaterina_kuznetsova';
update users set email  = 'dmitry_popov@gmail.com' where login = 'dmitry_popov';
update users set email  = 'olga_sokolova@gmail.com' where login = 'olga_sokolova';
update users set email  = 'nikolay_lebedev@gmail.com' where login = 'nikolay_lebedev';
update users set email  = 'anna_kozlova@gmail.com' where login = 'anna_kozlova';
update users set email  = 'mikhail_novikov@gmail.com' where login = 'mikhail_novikov';
update users set email  = 'elena_morozova@gmail.com' where login = 'elena_morozova';
update users set email  = 'sergey_volkov@gmail.com' where login = 'sergey_volkov';
update users set email  = 'viktoria_zaytseva@gmail.com' where login = 'viktoria_zaytseva';
update users set email  = 'alexander_sidorov@gmail.com' where login = 'alexander_sidorov';
update users set email  = 'yulia_borisova@gmail.com' where login = 'yulia_borisova';
update users set email  = 'kirill_fedorov@gmail.com' where login = 'kirill_fedorov';
update users set email  = 'anastasia_vasilyeva@gmail.com' where login = 'anastasia_vasilyeva';
update users set email  = 'pavel_mikhailov@gmail.com' where login = 'pavel_mikhailov';
update users set password = '$2a$12$5KBVakosZxnInUPgGNCZye4IBNW.qLVymMJIG1EI3vvPUwszD5/sG' where login = 'admin';

ALTER TABLE users ALTER COLUMN email SET NOT NULL;