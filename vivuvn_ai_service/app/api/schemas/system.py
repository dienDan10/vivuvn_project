"""System-level API schemas (health checks, errors)."""

from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class HealthCheckResponse(BaseModel):
    """Health check response schema."""

    status: str = Field(..., example="healthy")
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    version: str = Field(..., example="0.1.0")
    services: Optional[dict] = Field(
        None,
        example={
            "database": "healthy",
            "ai_service": "healthy",
            "vector_store": "healthy"
        }
    )


class ErrorResponse(BaseModel):
    """Error response schema."""

    error: dict = Field(
        ...,
        example={
            "message": "Invalid travel request",
            "code": "VALIDATION_ERROR",
            "details": {"field": "destination"}
        }
    )


__all__ = [
    "HealthCheckResponse",
    "ErrorResponse",
]
