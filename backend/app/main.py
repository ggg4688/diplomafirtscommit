from fastapi import FastAPI

from app.database import Base, engine
from app.middleware.logging_middleware import LoggingMiddleware
from app.routers import alerts_router, auth_router, incidents_router, users_router

# Ensure all models are imported before create_all.
from app.models import alert, asset, incident, incident_alert, incident_comment, user  # noqa: F401

app = FastAPI(title="Security Monitoring Platform API", version="1.0.0")
app.add_middleware(LoggingMiddleware)


@app.on_event("startup")
def on_startup() -> None:
    Base.metadata.create_all(bind=engine)


@app.get("/health", tags=["health"])
def health_check():
    return {"status": "ok"}


app.include_router(auth_router)
app.include_router(users_router)
app.include_router(alerts_router)
app.include_router(incidents_router)

