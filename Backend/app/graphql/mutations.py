from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session
import random
import string

from ..core.config import settings
from ..core.database import get_db
from ..models.models import (
    User as UserModel,
    FriendRequest as FriendRequestModel,
    Friendship as FriendshipModel,
    UserPreference as UserPreferenceModel,
    Favorite as FavoriteModel
)
from .types import (
    User, Token, FriendRequest, Friendship,
    UserPreference, Favorite, UserInput, LoginInput,
    FriendRequestInput, UserPreferenceInput, FavoriteInput,
    FriendRequestByCodeInput
)
import strawberry

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def get_password_hash(password: str):
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str):
    return pwd_context.verify(plain_password, hashed_password)

def generate_friend_code():
    # Generar un código aleatorio de 10 dígitos
    return ''.join(random.choices(string.digits, k=10))

def get_unique_friend_code(db):
    while True:
        code = generate_friend_code()
        existing = db.query(UserModel).filter(UserModel.friend_code == code).first()
        if not existing:
            return code

@strawberry.type
class Mutation:
    @strawberry.mutation
    def register(self, userData: UserInput) -> User:
        db = next(get_db())
        # Generar un código de amigo único
        friend_code = get_unique_friend_code(db)
        
        db_user = UserModel(
            email=userData.email,
            username=userData.username,
            hashed_password=get_password_hash(userData.password),
            first_name=userData.firstName,
            last_name=userData.lastName,
            condition=userData.condition,
            friend_code=friend_code
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return User(
            id=str(db_user.id),
            email=db_user.email,
            username=db_user.username,
            firstName=db_user.first_name,
            lastName=db_user.last_name,
            condition=db_user.condition,
            isActive=db_user.is_active,
            createdAt=db_user.created_at,
            friendCode=db_user.friend_code
        )

    @strawberry.mutation
    def login(self, loginData: LoginInput) -> Token:
        try:
            print(f"Intento de login con email: {loginData.email}")
            db = next(get_db())
            user = db.query(UserModel).filter(UserModel.email == loginData.email).first()
            
            if not user:
                print(f"Usuario no encontrado: {loginData.email}")
                raise ValueError("Usuario no encontrado")
                
            print(f"Verificando contraseña para usuario: {user.email}")
            if not verify_password(loginData.password, user.hashed_password):
                print(f"Contraseña incorrecta para usuario: {user.email}")
                raise ValueError("Contraseña incorrecta")

            print(f"Login exitoso para usuario: {user.email}")
            access_token = create_access_token({"sub": user.email})
            return Token(accessToken=access_token, tokenType="bearer")
        except Exception as e:
            print(f"Error en login: {str(e)}")
            raise ValueError(str(e))

    @strawberry.mutation
    def send_friend_request(self, info, friendRequest: FriendRequestInput) -> FriendRequest:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        
        # Validar que no se envíe solicitud a uno mismo
        if str(user.id) == friendRequest.receiverId:
            raise ValueError("No puedes enviarte una solicitud de amistad a ti mismo")
            
        # Validar que el usuario destino exista
        friend = db.query(UserModel).filter(UserModel.id == friendRequest.receiverId).first()
        if not friend:
            raise ValueError("El usuario destino no existe")
            
        # Verificar si ya existe una solicitud o amistad
        existing_request = db.query(FriendRequestModel).filter(
            ((FriendRequestModel.sender_id == user.id) & 
             (FriendRequestModel.receiver_id == friendRequest.receiverId)) |
            ((FriendRequestModel.sender_id == friendRequest.receiverId) & 
             (FriendRequestModel.receiver_id == user.id))
        ).first()
        
        if existing_request:
            if existing_request.status == "PENDING":
                if str(existing_request.sender_id) == str(user.id):
                    raise ValueError("Ya has enviado una solicitud de amistad a este usuario. Por favor, espera a que la acepte o rechace.")
                else:
                    raise ValueError("Este usuario ya te ha enviado una solicitud de amistad. Revisa la pestaña 'Recibidas'.")
            elif existing_request.status == "ACCEPTED":
                raise ValueError("Ya son amigos")
        
        # Verificar si ya son amigos
        existing_friendship = db.query(FriendshipModel).filter(
            ((FriendshipModel.user_id == user.id) & 
             (FriendshipModel.friend_id == friendRequest.receiverId)) |
            ((FriendshipModel.user_id == friendRequest.receiverId) & 
             (FriendshipModel.friend_id == user.id))
        ).first()
        
        if existing_friendship:
            raise ValueError("Ya son amigos")
        
        friend_request = FriendRequestModel(
            sender_id=user.id,
            receiver_id=friendRequest.receiverId,
            status="PENDING"
        )
        db.add(friend_request)
        db.commit()
        db.refresh(friend_request)
        
        return FriendRequest(
            id=str(friend_request.id),
            senderId=str(friend_request.sender_id),
            receiverId=str(friend_request.receiver_id),
            status=friend_request.status,
            createdAt=friend_request.created_at,
            updatedAt=friend_request.updated_at,
            sender=User(
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
            receiver=User(
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
        )

    @strawberry.mutation
    def accept_friend_request(self, info, requestId: str) -> Friendship:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        print(f"Aceptando solicitud {requestId} para usuario {user.email}")
        
        # Verificar todas las solicitudes pendientes del usuario
        all_requests = db.query(FriendRequestModel).filter(
            FriendRequestModel.receiver_id == user.id,
            FriendRequestModel.status.ilike("PENDING")
        ).all()
        print("Solicitudes pendientes encontradas:")
        for req in all_requests:
            print(f"ID: {req.id}, De: {req.sender_id}, Estado: {req.status}")
        
        # Imprimir la consulta SQL que se va a ejecutar
        query = db.query(FriendRequestModel).filter(
            FriendRequestModel.id == requestId,
            FriendRequestModel.receiver_id == user.id,
            FriendRequestModel.status.ilike("PENDING")
        )
        print(f"SQL Query: {str(query)}")
        
        # Obtener la solicitud
        friend_request = query.first()
        
        if not friend_request:
            print(f"Error: Solicitud {requestId} no encontrada para usuario {user.email}")
            raise ValueError("Solicitud de amistad no encontrada")
            
        # Verificar si ya existe una amistad
        existing_friendship = db.query(FriendshipModel).filter(
            ((FriendshipModel.user_id == friend_request.receiver_id) & 
             (FriendshipModel.friend_id == friend_request.sender_id)) |
            ((FriendshipModel.user_id == friend_request.sender_id) & 
             (FriendshipModel.friend_id == friend_request.receiver_id))
        ).first()

        if existing_friendship:
            print(f"Ya existe una amistad entre los usuarios")
            friend_request.status = "REJECTED"  # Rechazamos la solicitud ya que ya son amigos
            friend_request.updated_at = datetime.utcnow()
            db.commit()
            raise ValueError("Ya existe una amistad entre estos usuarios")

        # Crear la amistad
        friendship = FriendshipModel(
            user_id=friend_request.receiver_id,
            friend_id=friend_request.sender_id
        )
        
        # Actualizar el estado de la solicitud
        friend_request.status = "ACCEPTED"
        friend_request.updated_at = datetime.utcnow()
        
        try:
            db.add(friendship)
            db.commit()
            db.refresh(friendship)
            print(f"Solicitud {requestId} aceptada exitosamente")
            
            # Obtener el amigo para incluirlo en la respuesta
            friend = db.query(UserModel).filter(UserModel.id == friendship.friend_id).first()
            
            return Friendship(
                id=str(friendship.id),
                userId=str(friendship.user_id),
                friendId=str(friendship.friend_id),
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
                    friendCode=user.friend_code
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
                    friendCode=friend.friend_code
                )
            )
        except Exception as e:
            db.rollback()
            print(f"Error al guardar la amistad: {e}")
            raise ValueError("Error al aceptar la solicitud de amistad")

    @strawberry.mutation
    def reject_friend_request(self, info, requestId: str) -> FriendRequest:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        print(f"Rechazando solicitud {requestId} para usuario {user.email}")
        
        # Obtener la solicitud
        friend_request = db.query(FriendRequestModel).filter(
            FriendRequestModel.id == requestId,
            FriendRequestModel.receiver_id == user.id,
            FriendRequestModel.status == "PENDING"
        ).first()
        
        if not friend_request:
            print(f"Error: Solicitud {requestId} no encontrada para usuario {user.email}")
            raise ValueError("Solicitud de amistad no encontrada")
            
        # Actualizar el estado de la solicitud
        friend_request.status = "REJECTED"
        friend_request.updated_at = datetime.utcnow()
        
        try:
            db.commit()
            db.refresh(friend_request)
            print(f"Solicitud {requestId} rechazada exitosamente")
            
            # Obtener el remitente para incluirlo en la respuesta
            sender = db.query(UserModel).filter(UserModel.id == friend_request.sender_id).first()
            
            return FriendRequest(
                id=str(friend_request.id),
                senderId=str(friend_request.sender_id),
                receiverId=str(friend_request.receiver_id),
                status=friend_request.status,
                createdAt=friend_request.created_at,
                updatedAt=friend_request.updated_at,
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
                    lastName=user.lastName,
                    condition=user.condition,
                    isActive=user.is_active,
                    createdAt=user.created_at
                )
            )
        except Exception as e:
            db.rollback()
            print(f"Error al rechazar la solicitud: {e}")
            raise ValueError("Error al rechazar la solicitud de amistad")

    @strawberry.mutation
    def send_friend_request_by_code(self, info, request: FriendRequestByCodeInput) -> FriendRequest:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        
        # Buscar usuario por código de amigo
        friend = db.query(UserModel).filter(UserModel.friend_code == request.friendCode).first()
        if not friend:
            raise ValueError("No se encontró ningún usuario con ese código")
            
        # Validar que no se envíe solicitud a uno mismo
        if str(user.id) == str(friend.id):
            raise ValueError("No puedes enviarte una solicitud de amistad a ti mismo")
            
        # Verificar si ya existe una solicitud o amistad
        existing_request = db.query(FriendRequestModel).filter(
            ((FriendRequestModel.sender_id == user.id) & 
             (FriendRequestModel.receiver_id == friend.id)) |
            ((FriendRequestModel.sender_id == friend.id) & 
             (FriendRequestModel.receiver_id == user.id))
        ).first()
        
        if existing_request:
            if existing_request.status == "PENDING":
                if str(existing_request.sender_id) == str(user.id):
                    raise ValueError("Ya has enviado una solicitud de amistad a este usuario. Por favor, espera a que la acepte o rechace.")
                else:
                    raise ValueError("Este usuario ya te ha enviado una solicitud de amistad. Revisa la pestaña 'Recibidas'.")
            elif existing_request.status == "ACCEPTED":
                raise ValueError("Ya son amigos")
        
        # Verificar si ya son amigos
        existing_friendship = db.query(FriendshipModel).filter(
            ((FriendshipModel.user_id == user.id) & 
             (FriendshipModel.friend_id == friend.id)) |
            ((FriendshipModel.user_id == friend.id) & 
             (FriendshipModel.friend_id == user.id))
        ).first()
        
        if existing_friendship:
            raise ValueError("Ya son amigos")
        
        friend_request = FriendRequestModel(
            sender_id=user.id,
            receiver_id=friend.id,
            status="PENDING"
        )
        db.add(friend_request)
        db.commit()
        db.refresh(friend_request)
        
        return FriendRequest(
            id=str(friend_request.id),
            senderId=str(friend_request.sender_id),
            receiverId=str(friend_request.receiver_id),
            status=friend_request.status,
            createdAt=friend_request.created_at,
            updatedAt=friend_request.updated_at,
            sender=User(
                id=str(user.id),
                email=user.email,
                username=user.username,
                firstName=user.first_name,
                lastName=user.last_name,
                condition=user.condition,
                isActive=user.is_active,
                createdAt=user.created_at,
                friendCode=user.friend_code
            ),
            receiver=User(
                id=str(friend.id),
                email=friend.email,
                username=friend.username,
                firstName=friend.first_name,
                lastName=friend.last_name,
                condition=friend.condition,
                isActive=friend.is_active,
                createdAt=friend.created_at,
                friendCode=friend.friend_code
            )
        )

    @strawberry.mutation
    def add_favorite(self, info, favorite: FavoriteInput) -> Favorite:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        
        # Verificar si ya existe el favorito
        existing_favorite = db.query(FavoriteModel).filter(
            FavoriteModel.user_id == user.id,
            FavoriteModel.item_type == favorite.itemType,
            FavoriteModel.item_id == favorite.itemId
        ).first()
        
        if existing_favorite:
            print(f"El favorito ya existe para el usuario {user.email}")
            raise ValueError("Este elemento ya está en favoritos")
        
        # Crear nuevo favorito
        new_favorite = FavoriteModel(
            user_id=user.id,
            item_type=favorite.itemType,
            item_id=favorite.itemId
        )
        
        try:
            db.add(new_favorite)
            db.commit()
            db.refresh(new_favorite)
            
            print(f"Favorito agregado exitosamente para {user.email}")
            return Favorite(
                id=str(new_favorite.id),
                userId=str(new_favorite.user_id),
                itemType=new_favorite.item_type,
                itemId=new_favorite.item_id,
                createdAt=new_favorite.created_at
            )
        except Exception as e:
            db.rollback()
            print(f"Error al agregar favorito: {e}")
            raise ValueError("Error al agregar a favoritos")

    @strawberry.mutation
    def remove_favorite(self, info, itemType: str, itemId: str) -> bool:
        user = info.context.get("user")
        if not user:
            print("Error: Usuario no encontrado en el contexto")
            raise ValueError("No autenticado")
            
        db = next(get_db())
        
        # Buscar y eliminar el favorito
        favorite = db.query(FavoriteModel).filter(
            FavoriteModel.user_id == user.id,
            FavoriteModel.item_type == itemType,
            FavoriteModel.item_id == itemId
        ).first()
        
        if not favorite:
            print(f"Favorito no encontrado para el usuario {user.email}")
            raise ValueError("Favorito no encontrado")
        
        try:
            db.delete(favorite)
            db.commit()
            print(f"Favorito eliminado exitosamente para {user.email}")
            return True
        except Exception as e:
            db.rollback()
            print(f"Error al eliminar favorito: {e}")
            raise ValueError("Error al eliminar de favoritos")
