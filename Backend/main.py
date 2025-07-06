from fastapi import FastAPI, Request
import strawberry
from strawberry.fastapi import GraphQLRouter
from app.core.config import settings
from app.graphql.queries import Query
from app.graphql.mutations import Mutation
from app.core.auth import get_current_user

async def get_context(request: Request):
    user = await get_current_user(request)
    return {
        "request": request,
        "user": user
    }

# Crear el esquema de GraphQL
schema = strawberry.Schema(query=Query, mutation=Mutation)

# Crear el router de GraphQL con contexto
graphql_app = GraphQLRouter(
    schema,
    context_getter=get_context
)

# Crear la aplicación FastAPI
app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION
)

# Agregar el router de GraphQL
app.include_router(graphql_app, prefix="/graphql")

# Endpoint de salud
@app.get("/health")
def health_check():
    return {"status": "ok"}
