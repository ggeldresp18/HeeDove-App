-- Actualizar los estados existentes a mayúsculas
UPDATE friend_requests 
SET status = UPPER(status)
WHERE status != UPPER(status);

-- Verificar que todos los estados estén en mayúsculas
SELECT id, status 
FROM friend_requests 
WHERE status != UPPER(status);
