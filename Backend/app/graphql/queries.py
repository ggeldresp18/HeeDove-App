import strawberry
from typing import List, Optional
from sqlalchemy.orm import Session

from ..core.database import get_db
from ..models.models import (
    User as UserModel,
    Friendship as FriendshipModel,
    FriendRequest as FriendRequestModel,
    UserPreference as UserPreferenceModel,
    Favorite as FavoriteModel
)
from .types import (
    User, Friendship, FriendRequest,
    UserPreference, Favorite
)

@strawberry.type
class Query:
    @strawberry.field
    def me(self, info) -> User:
        user = info.context.get("user")
        if not user:
            raise ValueError("No autenticado")
            
        return User(
            id=str(user.id),
            email=user.email,
            username=user.username,
            firstName=user.first_name,
            lastName=user.last_name,
            condition=user.condition,
            isActive=user.is_active,
            createdAt=user.created_at,
            friendCode=user.friend_code or "0000000000"
        )

    @strawberry.field
    def my_friends(self, info) -> List[Friendship]:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        print(f"Buscando amigos para el usuario {user.email}")
        
        # Utilizamos un conjunto para rastrear amigos únicos
        seen_friends = set()
        result = []
        
        # Obtener todas las amistades del usuario
        friendships = db.query(FriendshipModel).filter(
            (FriendshipModel.user_id == user.id) |
            (FriendshipModel.friend_id == user.id)
        ).all()
        
        for friendship in friendships:
            # Determinar quién es el amigo basado en el ID del usuario actual
            friend_id = str(friendship.friend_id if str(friendship.user_id) == str(user.id) else friendship.user_id)
            
            # Si ya hemos visto este amigo, lo saltamos
            if friend_id in seen_friends:
                continue
                
            seen_friends.add(friend_id)
            
            friend = db.query(UserModel).filter(UserModel.id == friend_id).first()
            if friend:
                result.append(Friendship(
                    id=str(friendship.id),
                    userId=str(user.id),
                    friendId=friend_id,
                    createdAt=friendship.created_at,
                    user=User(
                        id=str(user.id),
                        email=user.email,
                        username=user.username,
                        firstName=user.first_name,
                        lastName=user.last_name,
                        condition=user.condition,
                        isActive=user.is_active,
                        createdAt=user.created_at,
                        friendCode=user.friend_code or "0000000000"
                    ),
                    friend=User(
                        id=str(friend.id),
                        email=friend.email,
                        username=friend.username,
                        firstName=friend.first_name,
                        lastName=friend.last_name,
                        condition=friend.condition,
                        isActive=friend.is_active,
                        createdAt=friend.created_at,
                        friendCode=friend.friend_code or "0000000000"
                    )
                ))
        
        print(f"Se encontraron {len(result)} amigos")
        return result

    @strawberry.field
    def get_received_friend_requests(self, info) -> List[FriendRequest]:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        print(f"Buscando solicitudes recibidas para el usuario {user.email} (ID: {user.id})")
        
        # Obtener todas las solicitudes pendientes recibidas
        requests = db.query(FriendRequestModel).filter(
            FriendRequestModel.receiver_id == user.id,
            FriendRequestModel.status.ilike("PENDING")  # Case-insensitive comparison
        ).all()
        
        # Imprimir detalles de la consulta
        print(f"SQL Query: {str(db.query(FriendRequestModel).filter(FriendRequestModel.receiver_id == user.id, FriendRequestModel.status == 'PENDING'))}")
        
        # Verificar todas las solicitudes en la base de datos para este usuario
        all_requests = db.query(FriendRequestModel).filter(
            FriendRequestModel.receiver_id == user.id
        ).all()
        print(f"Todas las solicitudes encontradas para {user.email}:")
        for req in all_requests:
            print(f"ID: {req.id}, De: {req.sender_id}, Estado: {req.status}")
        
        result = []
        for request in requests:
            sender = db.query(UserModel).filter(UserModel.id == request.sender_id).first()
            if sender:
                result.append(FriendRequest(
                    id=str(request.id),
                    senderId=str(request.sender_id),
                    receiverId=str(request.receiver_id),
                    status=request.status,
                    createdAt=request.created_at,
                    updatedAt=request.updated_at,
                    sender=User(
                        id=str(sender.id),
                        email=sender.email,
                        username=sender.username,
                        firstName=sender.first_name,
                        lastName=sender.last_name,
                        condition=sender.condition,
                        isActive=sender.is_active,
                        createdAt=sender.created_at
                    ),
                    receiver=User(
                        id=str(user.id),
                        email=user.email,
                        username=user.username,
                        firstName=user.first_name,
                        lastName=user.last_name,
                        condition=user.condition,
                        isActive=user.is_active,
                        createdAt=user.created_at
                    )
                ))
                
        print(f"Se encontraron {len(result)} solicitudes recibidas")
        return result

    @strawberry.field
    def get_sent_friend_requests(self, info) -> List[FriendRequest]:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        print(f"Buscando solicitudes enviadas por el usuario {user.email}")
        
        # Obtener todas las solicitudes enviadas
        requests = db.query(FriendRequestModel).filter(
            FriendRequestModel.sender_id == user.id,
            FriendRequestModel.status.ilike("PENDING")  # Solo mostrar las pendientes
        ).all()
        
        result = []
        for request in requests:
            receiver = db.query(UserModel).filter(UserModel.id == request.receiver_id).first()
            if receiver:
                result.append(FriendRequest(
                    id=str(request.id),
                    senderId=str(request.sender_id),
                    receiverId=str(request.receiver_id),
                    status=request.status,
                    createdAt=request.created_at,
                    updatedAt=request.updated_at,
                    sender=User(
                        id=str(user.id),
                        email=user.email,
                        username=user.username,
                        firstName=user.first_name,
                        lastName=user.last_name,
                        condition=user.condition,
                        isActive=user.is_active,
                        createdAt=user.created_at
                    ),
                    receiver=User(
                        id=str(receiver.id),
                        email=receiver.email,
                        username=receiver.username,
                        firstName=receiver.first_name,
                        lastName=receiver.last_name,
                        condition=receiver.condition,
                        isActive=receiver.is_active,
                        createdAt=receiver.created_at
                    )
                ))
                
        print(f"Se encontraron {len(result)} solicitudes enviadas")
        return result
