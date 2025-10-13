"""
Pydantic schemas for ViVu Vietnam AI Service API.

This module defines request and response models for API endpoints
with comprehensive validation and documentation.
"""

from datetime import date, datetime
from typing import List, Optional

from pydantic import BaseModel, Field, validator

# Import travel models from dedicated module
from app.models.travel_models import Activity, DayItinerary, TravelItinerary, TransportationSuggestion


class TravelRequest(BaseModel):
    """Request schema for travel itinerary generation."""
    
    origin: Optional[str] = Field(
        None,
        description="Starting location (if different from destination)",
        example="Hanoi",
        min_length=2,
        max_length=100
    )
    destination: str = Field(
        ...,
        description="Vietnam destination name",
        example="Ho Chi Minh City",
        min_length=2,
        max_length=100
    )
    start_date: date = Field(
        ...,
        description="Trip start date",
        example="2024-03-15"
    )
    end_date: date = Field(
        ...,
        description="Trip end date",
        example="2024-03-18"
    )
    preferences: List[str] = Field(
        default_factory=list,
        description="List of travel preferences",
        example=["food", "culture", "nature"]
    )
    group_size: int = Field(
        1,
        description="Number of travelers",
        example=2,
        ge=1,
        le=10
    )
    budget: Optional[int] = Field(
        None,
        description="Budget in VND (e.g., '5000000' for 5 million VND)",
        example=5000000
    )
    special_requirements: Optional[str] = Field(
        None,
        description="Special requirements or accessibility needs",
        example="Vegetarian meals required"
    )
    
    @validator("end_date")
    def validate_date_range(cls, v, values):
        """Validate that end_date is after start_date."""
        if "start_date" in values and v <= values["start_date"]:
            raise ValueError("End date must be after start date")
        return v
    
    @validator("start_date")
    def validate_start_date_not_past(cls, v):
        """Validate that start date is not in the past."""
        if v < date.today():
            raise ValueError("Start date cannot be in the past")
        return v
    
    @validator("preferences")
    def validate_preferences(cls, v):
        """Validate preference categories."""
        valid_preferences = {
            "food", "culture", "history", "nature", "adventure", "shopping",
            "nightlife", "beaches", "mountains", "cities", "rural", "art",
            "architecture", "museums", "temples", "markets", "local_life",
            "photography", "relaxation", "budget", "luxury"
        }
        for pref in v:
            if pref.lower() not in valid_preferences:
                raise ValueError(f"Invalid preference: {pref}")
        return [pref.lower() for pref in v]
    
    @validator("budget")
    def validate_budget(cls, v):
        """Validate budget."""
        if v is not None:
            if v < 0:
                raise ValueError("Budget cannot be negative")
            return v
        return v
    
    @property
    def duration_days(self) -> int:
        """Calculate trip duration in days."""
        return (self.end_date - self.start_date).days + 1


class TravelResponse(BaseModel):
    """Response schema for travel itinerary generation."""
    
    success: bool = Field(
        ...,
        description="Whether the itinerary generation was successful",
        example=True
    )
    message: str = Field(
        ...,
        description="Response message",
        example="Itinerary generated successfully"
    )
    itinerary: Optional[TravelItinerary] = Field(
        None,
        description="Generated travel itinerary"
    )
    weather_info: Optional[str] = Field(
        None,
        description="Weather information for the travel period",
        example="Warm and humid, 26-33°C with occasional rain"
    )


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


# Data Management Schemas

class DataInsertRequest(BaseModel):
    """Request schema for inserting data items."""
    
    item_type: str = Field(
        ...,
        description="Type of item to insert",
        example="destination"
    )
    data: dict = Field(
        ...,
        description="Item data dictionary",
        example={
            "name": "Da Nang",
            "region": "Central",
            "description": "Coastal city with beautiful beaches"
        }
    )
    
    @validator('item_type')
    def validate_item_type(cls, v):
        if v not in ['destination', 'attraction', 'activity']:
            raise ValueError('item_type must be one of: destination, attraction, activity')
        return v


class DataInsertResponse(BaseModel):
    """Response schema for data insert operations."""
    
    success: bool = Field(..., description="Operation success status")
    message: str = Field(..., description="Result message")
    item_id: Optional[str] = Field(None, description="Inserted item ID")
    item_type: str = Field(..., description="Type of item inserted")


class DataDeleteRequest(BaseModel):
    """Request schema for deleting data items."""
    
    item_id: str = Field(
        ...,
        description="ID of item to delete",
        example="550e8400-e29b-41d4-a716-446655440000"
    )


class DataDeleteResponse(BaseModel):
    """Response schema for data delete operations."""
    
    success: bool = Field(..., description="Operation success status")
    message: str = Field(..., description="Result message")
    item_id: str = Field(..., description="Deleted item ID")


class DataBatchUploadResponse(BaseModel):
    """Response schema for batch upload operations."""
    
    success: bool = Field(..., description="Operation success status")
    message: str = Field(..., description="Result message")
    uploaded_count: int = Field(..., description="Number of items uploaded")
    data_type: str = Field(..., description="Type of data uploaded")
    filename: Optional[str] = Field(None, description="Original filename")


# Export all schemas
__all__ = [
    # Travel Models (imported from app.models.travel_models)
    "Activity",
    "DayItinerary", 
    "TravelItinerary",
    "TransportationSuggestion",
    
    # API Request/Response Schemas
    "TravelRequest",
    "TravelResponse",
    
    # System Schemas
    "HealthCheckResponse",
    "ErrorResponse",
    
    # Data Management Schemas
    "DataInsertRequest",
    "DataInsertResponse",
    "DataDeleteRequest",
    "DataDeleteResponse",
    "DataBatchUploadResponse",
]