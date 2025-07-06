-- Eliminar la columna status de la tabla friendships
ALTER TABLE friendships DROP COLUMN IF EXISTS status;
