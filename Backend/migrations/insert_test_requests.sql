-- Ver los usuarios disponibles
SELECT id, email, username, first_name, last_name FROM users;

-- Insertar solicitudes de amistad de prueba
INSERT INTO friend_requests (
    sender_id,
    receiver_id,
    status,
    created_at,
    updated_at
) VALUES 
    -- Solicitud de test@example.com a amigo@example.com
    ('4454a81c-98ed-4b20-82bb-f8640e7a0758', '9a2e10f0-1ed2-484f-afa2-cc5c52efcd57', 'PENDING', NOW(), NOW()),
    
    -- Solicitud de gavino@example.com a gavinogeldresp@gmail.com
    ('684a9030-638b-40e4-ae68-25d2c9bbc580', 'a4f5e75b-657c-47c9-b69b-f7a392ebfba8', 'PENDING', NOW(), NOW()),
    
    -- Solicitud de gavino@gmail.com a amigo@example.com
    ('961ac984-a288-4b94-96bf-594fabcbce97', '9a2e10f0-1ed2-484f-afa2-cc5c52efcd57', 'PENDING', NOW(), NOW()),
    
    -- Solicitud de gavinogeldresp@gmail.com a test@example.com
    ('a4f5e75b-657c-47c9-b69b-f7a392ebfba8', '4454a81c-98ed-4b20-82bb-f8640e7a0758', 'PENDING', NOW(), NOW());

-- Ver las solicitudes creadas
SELECT 
    fr.id,
    sender.email as sender_email,
    receiver.email as receiver_email,
    fr.status,
    fr.created_at
FROM friend_requests fr
JOIN users sender ON fr.sender_id = sender.id
JOIN users receiver ON fr.receiver_id = receiver.id;
