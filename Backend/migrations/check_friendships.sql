-- Ver todos los usuarios para referencia
SELECT id, email, username
FROM users
ORDER BY email;

-- Ver todas las amistades
SELECT 
    f.id as friendship_id,
    u1.email as user_email,
    u2.email as friend_email,
    f.created_at
FROM friendships f
JOIN users u1 ON f.user_id = u1.id
JOIN users u2 ON f.friend_id = u2.id
ORDER BY f.created_at DESC;

-- Ver amistades específicas para amigo@example.com
SELECT 
    f.id as friendship_id,
    u1.email as user_email,
    u2.email as friend_email,
    f.created_at
FROM friendships f
JOIN users u1 ON f.user_id = u1.id
JOIN users u2 ON f.friend_id = u2.id
WHERE u1.email = 'amigo@example.com'
   OR u2.email = 'amigo@example.com'
ORDER BY f.created_at DESC;

-- Ver solicitudes de amistad pendientes
SELECT 
    fr.id as request_id,
    u1.email as sender_email,
    u2.email as receiver_email,
    fr.status,
    fr.created_at,
    fr.updated_at
FROM friend_requests fr
JOIN users u1 ON fr.sender_id = u1.id
JOIN users u2 ON fr.receiver_id = u2.id
WHERE fr.status = 'pending'
ORDER BY fr.created_at DESC;
