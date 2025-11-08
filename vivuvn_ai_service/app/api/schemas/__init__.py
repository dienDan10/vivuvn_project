"""
API Schemas for ViVu Vietnam AI Service.

This package contains request and response models for all API endpoints.
Each schema class is in its own module for better organization.

Structure:
  - place.py         - PlaceData, PlaceInsertRequest/Response, PlaceUpdateRequest/Response
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
    PlaceData,
    PlaceInsertRequest,
    PlaceInsertResponse,
    PlaceUpdateRequest,
    PlaceUpdateResponse,
)

# Generic Data Management Schemas
from app.api.schemas.data import (
    DataDeleteRequest,
    DataDeleteResponse,
    DataBatchUploadResponse,
)

# Backward Compatibility Aliases (Deprecated)
DataInsertRequest = PlaceInsertRequest
DataInsertResponse = PlaceInsertResponse
DataUpdateRequest = PlaceUpdateRequest
DataUpdateResponse = PlaceUpdateResponse

# Export all schemas
__all__ = [
    # Travel Schemas
    "TravelRequest",
    "TravelResponse",

    # System Schemas
    "HealthCheckResponse",
    "ErrorResponse",

    # Place Data Management Schemas
    "PlaceData",
    "PlaceInsertRequest",
    "PlaceInsertResponse",
    "PlaceUpdateRequest",
    "PlaceUpdateResponse",

    # Generic Data Management Schemas
    "DataDeleteRequest",
    "DataDeleteResponse",
    "DataBatchUploadResponse",

    # Backward Compatibility (Deprecated)
    "DataInsertRequest",
    "DataInsertResponse",
    "DataUpdateRequest",
    "DataUpdateResponse",
]
