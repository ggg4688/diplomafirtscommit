from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class AssetCreate(BaseModel):
    hostname: str = Field(min_length=1, max_length=255)
    ip_address: str = Field(min_length=1, max_length=45)


class AssetUpdate(BaseModel):
    hostname: str | None = Field(default=None, min_length=1, max_length=255)
    ip_address: str | None = Field(default=None, min_length=1, max_length=45)


class AssetRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    hostname: str
    ip_address: str
    created_at: datetime


class AlertCreate(BaseModel):
    title: str = Field(min_length=1, max_length=255)
    description: str = Field(min_length=1)
    severity: str = Field(min_length=1, max_length=30)
    asset_id: int


class AlertUpdate(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    description: str | None = Field(default=None, min_length=1)
    severity: str | None = Field(default=None, min_length=1, max_length=30)
    asset_id: int | None = None


class AlertRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    description: str
    severity: str
    asset_id: int
    created_at: datetime

