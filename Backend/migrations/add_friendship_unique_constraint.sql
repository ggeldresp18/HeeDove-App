-- Primero, eliminamos cualquier duplicado existente manteniendo la amistad más antigua
WITH RankedFriendships AS (
    SELECT id,
           user_id,
           friend_id,
           created_at,
           ROW_NUMBER() OVER (
               PARTITION BY LEAST(user_id, friend_id), GREATEST(user_id, friend_id)
               ORDER BY created_at ASC
           ) as rn
    FROM friendships
)
DELETE FROM friendships
WHERE id IN (
    SELECT id
    FROM RankedFriendships
    WHERE rn > 1
);

-- Luego, agregamos la restricción única
CREATE UNIQUE INDEX IF NOT EXISTS unique_friendship 
ON friendships (
    LEAST(user_id, friend_id), 
    GREATEST(user_id, friend_id)
);
