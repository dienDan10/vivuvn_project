"""
API Schemas for ViVu Vietnam AI Service.

This package contains request and response models for all API endpoints.
Each schema class is in its own module for better organization.

Structure:
  - place.py         - PlaceUpsertRequest/Response
  - travel.py        - TravelRequest, TravelResponse
  - data.py          - DataDeleteRequest/Response, DataBatchUploadResponse
  - system.py        - HealthCheckResponse, ErrorResponse
"""

# Travel Schemas
from app.api.schemas.travel import (
    TravelRequest,
    TravelResponse,
)

# System Schemas
from app.api.schemas.system import (
    HealthCheckResponse,
    ErrorResponse,
)

# Place Data Management Schemas
from app.api.schemas.place import (
    PlaceUpsertRequest,
    PlaceUpsertResponse,
)

# Generic Data Management Schemas
from app.api.schemas.data import (
    DataDeleteRequest,
    DataDeleteResponse,
)

# Export all schemas
__all__ = [
    # Travel Schemas
    "TravelRequest",
    "TravelResponse",

    # System Schemas
    "HealthCheckResponse",
    "ErrorResponse",

    # Place Data Management Schemas
    "PlaceUpsertRequest",
    "PlaceUpsertResponse",

    # Generic Data Management Schemas
    "DataDeleteRequest",
    "DataDeleteResponse",
]
