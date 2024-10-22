--liquibase formatted sql
--changeset Kamilla:026
update users
set register_date='2023-09-01' where login='alexey_ivanov';

update users
set register_date='2023-09-01' where login='maria_petrova';