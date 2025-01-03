--liquibase formatted sql
--changeset Kamilla:026
update users
set avatar = null where users.login = 'ivan_smirnov';
update users
set avatar = null where users.login='ekaterina_kuznetsova';
update users
set avatar = null where users.login='dmitry_popov';
update users
set avatar = null where users.login='olga_sokolova';
update users
set avatar = null where users.login='nikolay_lebedev';
update users
set avatar = null where users.login='anna_kozlova';
update users
set avatar = null where users.login='mikhail_novikov';
update users
set avatar = null where users.login='elena_morozova';
update users
set avatar = null where users.login='sergey_volkov';
update users
set avatar = null where users.login='viktoria_zaytseva';
update users
set avatar = null where users.login='alexander_sidorov';

update users
set avatar = null where users.login='yulia_borisova';

update users
set avatar = null where users.login='kirill_fedorov';
update users
set avatar = null where users.login='anastasia_vasilyeva';
update users
set avatar = null where users.login='pavel_mikhailov';
update users
set avatar = null where users.login='alexey_ivanov';
update users
set avatar = null where users.login='maria_petrova';
