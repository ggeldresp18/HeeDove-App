from fastapi import Request, HTTPException
from jose import JWTError, jwt
from typing import Optional
from sqlalchemy.orm import Session
from .config import settings
from .database import get_db
from ..models.models import User

async def get_current_user(request: Request) -> Optional[User]:
    try:
        auth_header = request.headers.get('Authorization')
        print(f"Auth header recibido: {auth_header}")
        if not auth_header:
            print("No se encontró header de autorización")
            return None

        scheme, token = auth_header.split()
        print(f"Scheme: {scheme}, Token length: {len(token)}")
        if scheme.lower() != 'bearer':
            print(f"Scheme inválido: {scheme}")
            return None

        try:
            payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
            print(f"Token decodificado exitosamente. Payload: {payload}")
        except JWTError as e:
            print(f"Error al decodificar token: {e}")
            return None

        email: str = payload.get("sub")
        if email is None:
            print("No se encontró email en el payload")
            return None

        # Obtener el usuario de la base de datos
        db: Session = next(get_db())
        user = db.query(User).filter(User.email == email).first()
        if user is None:
            print(f"No se encontró usuario con email: {email}")
            return None

        print(f"Usuario autenticado exitosamente: {user.email}")
        request.state.user = user
        return user
    except Exception as e:
        print(f"Error inesperado al obtener usuario: {e}")
        return None
