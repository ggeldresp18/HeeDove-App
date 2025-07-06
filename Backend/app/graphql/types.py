import strawberry
from datetime import datetime
from typing import List, Optional

@strawberry.type
class User:
    id: str
    email: str
    username: str
    firstName: str
    lastName: str
    condition: str
    isActive: bool
    createdAt: datetime
    friendCode: str  # Agregamos el código de amigo

@strawberry.type
class Token:
    accessToken: str
    tokenType: str

@strawberry.type
class FriendRequest:
    id: str
    senderId: str
    receiverId: str
    status: str
    createdAt: datetime
    updatedAt: datetime
    sender: Optional['User']
    receiver: Optional['User']

@strawberry.type
class Friendship:
    id: str
    userId: str
    friendId: str
    createdAt: datetime
    user: Optional['User']
    friend: Optional['User']

@strawberry.type
class UserPreference:
    id: str
    userId: str
    fontSize: int
    highContrast: bool
    textToSpeech: bool

@strawberry.type
class Favorite:
    id: str
    userId: str
    itemType: str
    itemId: str
    createdAt: datetime

@strawberry.input
class UserInput:
    email: str
    username: str
    password: str
    firstName: str
    lastName: str
    condition: str

@strawberry.input
class LoginInput:
    email: str
    password: str

@strawberry.input
class FriendRequestInput:
    receiverId: str

@strawberry.input
class UserPreferenceInput:
    fontSize: Optional[int] = 16
    highContrast: Optional[bool] = False
    textToSpeech: Optional[bool] = False

@strawberry.input
class FavoriteInput:
    itemType: str
    itemId: str

@strawberry.input
class FriendRequestByCodeInput:
    friendCode: str
