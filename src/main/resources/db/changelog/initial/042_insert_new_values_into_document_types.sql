--liquibase formatted sql
--changeset Adil:042
DELETE FROM tasks
    USING document_types
WHERE tasks.document_type_id = document_types.id
  AND document_types.name = '161 форма';

DELETE FROM document_types
WHERE name = '161 форма';

INSERT INTO document_types (name) VALUES ('161 форма');
