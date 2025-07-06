-- Agregar nuevos campos a la tabla users
ALTER TABLE users
ADD COLUMN IF NOT EXISTS first_name VARCHAR(255),
ADD COLUMN IF NOT EXISTS last_name VARCHAR(255),
ADD COLUMN IF NOT EXISTS condition VARCHAR(255);

-- Actualizar los campos existentes con valores por defecto
UPDATE users
SET 
    first_name = 'Usuario',
    last_name = 'Anónimo',
    condition = 'No especificado'
WHERE first_name IS NULL;
