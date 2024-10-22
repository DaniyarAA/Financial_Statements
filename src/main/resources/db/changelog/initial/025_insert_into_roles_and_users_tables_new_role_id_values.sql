--liquibase formatted sql
--changeset Kamilla:025
update roles
set role='ADMIN'
where role = 'ROLE_ADMIN';

update roles
set role='ACCOUNTANT'
where role = 'ROLE_ACCOUNTANT';

update roles
set role='MANAGER'
where role = 'ROLE_MANAGER';

insert into roles(role)
values ('JUNIOR ADMIN');

update users
set role_id = (select id from roles where role = 'ADMIN' limit 1),
    avatar='static/user.png'
where login = 'alexey_ivanov';

update users
set role_id = (select id from roles where role = 'MANAGER' limit 1),
    avatar='static/user.png'
where login = 'maria_petrova';

update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'ivan_smirnov';

update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'ekaterina_kuznetsova';

update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'dmitry_popov';

update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'olga_sokolova';
update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'nikolay_lebedev';
update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'anna_kozlova';
update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'mikhail_novikov';
update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'elena_morozova';
update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'sergey_volkov';
update users
set role_id      = (select id from roles where roles.role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'viktoria_zaytseva';

update users
set role_id      = (select id from roles where role = 'ACCOUNTANT' limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'alexander_sidorov';

update users
set role_id      = (select id
                    from roles
                    where role = 'ACCOUNTANT'
                    limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'yulia_borisova';

update users
set role_id      = (select id
                    from roles
                    where role = 'ACCOUNTANT'
                    limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'kirill_fedorov';

update users
set role_id      = (select id
                    from roles
                    where role = 'ACCOUNTANT'
                    limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'anastasia_vasilyeva';

update users
set role_id      = (select id
                    from roles
                    where role = 'ACCOUNTANT'
                    limit 1),
    avatar='static/user.png',
    register_date=now()
where login = 'pavel_mikhailov';

update companies
set is_deleted = false where name = 'ОсОО "ТехноПроект"';