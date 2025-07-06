-- Agregar columna friend_code a la tabla users
ALTER TABLE users ADD COLUMN IF NOT EXISTS friend_code VARCHAR(10);

-- Generar códigos aleatorios únicos para usuarios existentes que no tienen código
UPDATE users 
SET friend_code = LPAD(FLOOR(RANDOM() * 10000000000)::TEXT, 10, '0')
WHERE friend_code IS NULL;

-- Hacer el friend_code único y no nulo
ALTER TABLE users ALTER COLUMN friend_code SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS unique_friend_code ON users (friend_code);
