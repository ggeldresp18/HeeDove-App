-- Migrar las solicitudes pendientes a la nueva tabla
INSERT INTO friend_requests (id, sender_id, receiver_id, status, created_at, updated_at)
SELECT 
    id,
    user_id as sender_id,
    friend_id as receiver_id,
    status,
    created_at,
    created_at as updated_at
FROM friendships
WHERE status = 'pending';

-- Migrar las amistades aceptadas
INSERT INTO friendships (id, user_id, friend_id, created_at)
SELECT 
    id,
    user_id,
    friend_id,
    created_at
FROM friendships
WHERE status = 'accepted';

-- Borrar los registros migrados de la tabla antigua
-- Este paso es opcional, puedes comentarlo si prefieres mantener los datos antiguos
-- DELETE FROM friendships WHERE status IN ('pending', 'accepted');

-- Ver el resultado de la migración
SELECT 'Solicitudes migradas:', COUNT(*) FROM friend_requests;
SELECT 'Amistades migradas:', COUNT(*) FROM friendships;
