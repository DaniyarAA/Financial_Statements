--liquibase formatted sql
--changeset Adil:038

UPDATE tasks
SET
    amount = 50000.00,
    description = 'Необходимо завершить 161 форму'
WHERE
    status_id = 1 AND start_datetime = '2024-10-31 09:00:00';

UPDATE tasks
SET
    amount = 20000.00,
    description = 'ЕН отчет успешно сдан'
WHERE
    status_id = 2 AND start_datetime = '2024-10-11 10:00:00';

UPDATE tasks
SET
    amount = 30000.00,
    description = 'В процессе выполнения 161 формы'
WHERE
    status_id = 3 AND start_datetime = '2024-10-31 11:00:00';

UPDATE tasks
SET
    amount = 40000.00,
    description = 'Необходимо завершить 161 форму'
WHERE
    status_id = 2 AND start_datetime = '2024-10-31 09:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = '161 форма' LIMIT 1);

UPDATE tasks
SET
    amount = 25000.00,
    description = 'ЕН отчет сдан в срок'
WHERE
    status_id = 4 AND start_datetime = '2024-10-11 10:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = 'ЕН отчет' LIMIT 1);

UPDATE tasks
SET
    amount = 60000.00,
    description = 'Просрочено: требуется выполнить'
WHERE
    status_id = 5 AND start_datetime = '2024-09-30 09:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = 'Статком' LIMIT 1);

UPDATE tasks
SET
    amount = 55000.00,
    description = '161 форма успешно сдана'
WHERE
    status_id = 5 AND start_datetime = '2024-09-30 10:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = '161 форма' LIMIT 1);

UPDATE tasks
SET
    amount = 70000.00,
    description = 'Просрочен: требуется выполнить'
WHERE
    status_id = 1 AND start_datetime = '2024-09-30 09:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = 'Статком' LIMIT 1);

UPDATE tasks
SET
    amount = 80000.00,
    description = 'ЭСФ успешно сдана'
WHERE
    status_id = 3 AND start_datetime = '2024-10-31 10:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = 'ЭСФ' LIMIT 1);

UPDATE tasks
SET
    amount = 90000.00,
    description = 'Необходимо завершить 161 форму'
WHERE
    status_id = 3 AND start_datetime = '2024-10-31 09:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = '161 форма' LIMIT 1);

UPDATE tasks
SET
    amount = 100000.00,
    description = '161 форма успешно сдана'
WHERE
    status_id = 6 AND start_datetime = '2024-09-30 10:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = '161 форма' LIMIT 1);

UPDATE tasks
SET
    amount = 110000.00,
    description = 'Необходимо завершить ЕН отчет'
WHERE
    status_id = 2 AND start_datetime = '2024-10-31 09:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = 'ЕН отчет' LIMIT 1);

UPDATE tasks
SET
    amount = 120000.00,
    description = 'Инвест успешно сдан'
WHERE
    status_id = 6 AND start_datetime = '2024-10-31 10:00:00' AND document_type_id = (SELECT id FROM document_types WHERE name = 'Инвест' LIMIT 1);