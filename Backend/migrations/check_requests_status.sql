-- Verificar todas las solicitudes de amistad y su estado actual
SELECT 
    fr.id as request_id,
    sender.email as sender_email,
    receiver.email as receiver_email,
    fr.status,
    fr.created_at,
    fr.updated_at
FROM friend_requests fr
JOIN users sender ON fr.sender_id = sender.id
JOIN users receiver ON fr.receiver_id = receiver.id
ORDER BY fr.created_at DESC;

-- Verificar específicamente las solicitudes para amigo@example.com
SELECT 
    fr.id as request_id,
    sender.email as sender_email,
    receiver.email as receiver_email,
    fr.status,
    fr.created_at,
    fr.updated_at
FROM friend_requests fr
JOIN users sender ON fr.sender_id = sender.id
JOIN users receiver ON fr.receiver_id = receiver.id
WHERE receiver.email = 'amigo@example.com'
   OR sender.email = 'amigo@example.com'
ORDER BY fr.created_at DESC;

-- Verificar si hay solicitudes en estado PENDING
SELECT 
    fr.id as request_id,
    sender.email as sender_email,
    receiver.email as receiver_email,
    fr.status,
    fr.created_at,
    fr.updated_at
FROM friend_requests fr
JOIN users sender ON fr.sender_id = sender.id
JOIN users receiver ON fr.receiver_id = receiver.id
WHERE fr.status = 'PENDING'
ORDER BY fr.created_at DESC;
