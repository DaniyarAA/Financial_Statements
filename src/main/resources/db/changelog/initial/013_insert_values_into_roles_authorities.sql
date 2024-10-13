--liquibase formatted sql
--changeset Daniyar:013
INSERT INTO roles_authorities (role_id, authority_id) VALUES
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'VIEW_COMPANIES')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'CREATE_COMPANIES')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'EDIT_COMPANIES')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'VIEW_TASKS')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'CREATE_TASKS')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'EDIT_TASKS')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'VIEW_USERS')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'CREATE_USERS')),
((SELECT id FROM roles WHERE role = 'ROLE_ADMIN'), (SELECT id FROM authorities WHERE authority = 'EDIT_USERS')),
((SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT'), (SELECT id FROM authorities WHERE authority = 'VIEW_COMPANIES')),
((SELECT id FROM roles WHERE role = 'ROLE_ACCOUNTANT'), (SELECT id FROM authorities WHERE authority = 'VIEW_TASKS')),
((SELECT id FROM roles WHERE role = 'ROLE_MANAGER'), (SELECT id FROM authorities WHERE authority = 'VIEW_COMPANIES')),
((SELECT id FROM roles WHERE role = 'ROLE_MANAGER'), (SELECT id FROM authorities WHERE authority = 'VIEW_TASKS')),
((SELECT id FROM roles WHERE role = 'ROLE_MANAGER'), (SELECT id FROM authorities WHERE authority = 'VIEW_USERS'));


