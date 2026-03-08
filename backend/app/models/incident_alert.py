from __future__ import annotations

from sqlalchemy import ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class IncidentAlert(Base):
    __tablename__ = "incident_alerts"
    __table_args__ = (UniqueConstraint("incident_id", "alert_id", name="uq_incident_alert"),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    incident_id: Mapped[int] = mapped_column(
        ForeignKey("incidents.id", ondelete="CASCADE"),
        nullable=False,
    )
    alert_id: Mapped[int] = mapped_column(
        ForeignKey("alerts.id", ondelete="CASCADE"),
        nullable=False,
    )

    incident: Mapped["Incident"] = relationship("Incident", back_populates="alert_links")
    alert: Mapped["Alert"] = relationship("Alert", back_populates="incident_links")

