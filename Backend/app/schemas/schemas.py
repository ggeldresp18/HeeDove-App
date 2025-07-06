from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional, List

class UserBase(BaseModel):
    email: EmailStr
    username: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    class Config:
        orm_mode = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

class FriendshipBase(BaseModel):
    friend_id: int

class FriendshipCreate(FriendshipBase):
    pass

class Friendship(FriendshipBase):
    id: int
    user_id: int
    status: str
    created_at: datetime

    class Config:
        orm_mode = True

class UserPreferenceBase(BaseModel):
    font_size: Optional[int] = 16
    high_contrast: Optional[bool] = False
    text_to_speech: Optional[bool] = False

class UserPreferenceCreate(UserPreferenceBase):
    pass

class UserPreference(UserPreferenceBase):
    id: int
    user_id: int

    class Config:
        orm_mode = True

class FavoriteBase(BaseModel):
    item_type: str
    item_id: str

class FavoriteCreate(FavoriteBase):
    pass

class Favorite(FavoriteBase):
    id: int
    user_id: int
    created_at: datetime

    class Config:
        orm_mode = True
