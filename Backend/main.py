import strawberry
from fastapi import FastAPI
from strawberry.fastapi import GraphQLRouter

# Simulación de base de datos
USUARIOS = {"admin": "123"}

@strawberry.type
class AuthPayload:
    success: bool
    message: str

@strawberry.type
class Mutation:
    @strawberry.mutation
    def login(self, username: str, password: str) -> AuthPayload:
        if username in USUARIOS and USUARIOS[username] == password:
            return AuthPayload(success=True, message="Login correcto")
        return AuthPayload(success=False, message="Credenciales incorrectas")

@strawberry.type
class Query:
    hello: str = "Hola mundo"  # Requisito mínimo para el esquema

# Crear el esquema completo con query y mutation
schema = strawberry.Schema(query=Query, mutation=Mutation)

# Configuración de FastAPI y ruta GraphQL
graphql_app = GraphQLRouter(schema)
app = FastAPI()
app.include_router(graphql_app, prefix="/graphql")
