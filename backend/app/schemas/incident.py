from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class IncidentCreate(BaseModel):
    title: str = Field(min_length=1, max_length=255)
    description: str = Field(min_length=1)
    status: str = Field(default="open", min_length=1, max_length=50)


class IncidentUpdate(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    description: str | None = Field(default=None, min_length=1)
    status: str | None = Field(default=None, min_length=1, max_length=50)


class IncidentRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    description: str
    status: str
    created_at: datetime


class IncidentAlertLinkCreate(BaseModel):
    alert_id: int


class IncidentAlertLinkRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    incident_id: int
    alert_id: int


class IncidentCommentCreate(BaseModel):
    comment: str = Field(min_length=1)


class IncidentCommentRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    incident_id: int
    user_id: int
    comment: str
    created_at: datetime

