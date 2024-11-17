--liquibase formatted sql
--changeset Kamilla:050

UPDATE users
SET login = 'admin' where users.login ='alexey_ivanov';

UPDATE users
SET credentials_updated = false where login ='admin';

update users
set password = '$2a$12$/twCiLYBt0YArlbhPLIcYumIFDcJd0MwGW2hIJISP4p2ecpMhBXe.
' where users.login = 'admin'