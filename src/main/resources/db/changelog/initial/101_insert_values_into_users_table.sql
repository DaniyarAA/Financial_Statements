--liquibase formatted sql
--changeset Daniyar:010
--passwords: 123
INSERT INTO users (name, surname, birthday, login, password, enabled) VALUES
('Алексей', 'Иванов', '1990-01-15', 'alexey_ivanov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Мария', 'Петрова', '1988-05-23', 'maria_petrova', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Иван', 'Смирнов', '1992-03-11', 'ivan_smirnov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Екатерина', 'Кузнецова', '1995-07-19', 'ekaterina_kuznetsova', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Дмитрий', 'Попов', '1985-11-30', 'dmitry_popov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Ольга', 'Соколова', '1993-04-05', 'olga_sokolova', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Николай', 'Лебедев', '1989-08-22', 'nikolay_lebedev', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Анна', 'Козлова', '1991-12-14', 'anna_kozlova', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Михаил', 'Новиков', '1994-06-10', 'mikhail_novikov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Елена', 'Морозова', '1996-09-03', 'elena_morozova', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Сергей', 'Волков', '1990-10-27', 'sergey_volkov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Виктория', 'Зайцева', '1992-02-17', 'viktoria_zaytseva', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Александр', 'Сидоров', '1987-11-20', 'alexander_sidorov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Юлия', 'Борисова', '1993-07-09', 'yulia_borisova', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Кирилл', 'Федоров', '1989-03-14', 'kirill_fedorov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Анастасия', 'Васильева', '1995-05-25', 'anastasia_vasilyeva', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true),
('Павел', 'Михайлов', '1991-04-12', 'pavel_mikhailov', '$2a$12$VY85Li9r92YdICRF3njFfeJJN3zsdzDLJKfaD5E7XZGMzxD6Kcumy', true);
