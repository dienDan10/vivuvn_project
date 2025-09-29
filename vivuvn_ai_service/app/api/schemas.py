"""
Pydantic schemas for ViVu Vietnam AI Service API.

This module defines request and response models for API endpoints
with comprehensive validation and documentation.
"""

from datetime import date, datetime
from typing import List, Optional

from pydantic import BaseModel, Field, validator


class Activity(BaseModel):
    """Individual activity within a day's itinerary."""
    
    time: str = Field(
        ...,
        description="Activity start time (HH:MM format)",
        example="09:00"
    )
    name: str = Field(
        ...,
        description="Name of the activity",
        example="Visit War Remnants Museum"
    )
    description: str = Field(
        ...,
        description="Detailed description of the activity",
        example="Learn about Vietnam War history through exhibits and artifacts"
    )
    location: str = Field(
        ...,
        description="Activity location address",
        example="28 Vo Van Tan, District 3, Ho Chi Minh City"
    )
    duration: str = Field(
        ...,
        description="Expected duration of the activity",
        example="2 hours"
    )
    cost_estimate: Optional[float] = Field(
        None,
        description="Estimated cost in VND",
        example=15000.0
    )
    category: str = Field(
        ...,
        description="Activity category",
        example="history"
    )
    
    @validator("time")
    def validate_time_format(cls, v):
        """Validate time format (HH:MM)."""
        try:
            hour, minute = map(int, v.split(":"))
            if not (0 <= hour <= 23 and 0 <= minute <= 59):
                raise ValueError("Invalid time range")
            return v
        except (ValueError, AttributeError):
            raise ValueError("Time must be in HH:MM format")
    
    @validator("cost_estimate")
    def validate_cost(cls, v):
        """Validate cost is non-negative."""
        if v is not None and v < 0:
            raise ValueError("Cost estimate cannot be negative")
        return v
    
    @validator("category")
    def validate_category(cls, v):
        """Validate activity category."""
        valid_categories = {
            "food", "sightseeing", "culture", "history", "nature", 
            "adventure", "shopping", "entertainment", "relaxation",
            "transportation", "accommodation", "other"
        }
        if v.lower() not in valid_categories:
            raise ValueError(f"Category must be one of: {', '.join(valid_categories)}")
        return v.lower()


class DayItinerary(BaseModel):
    """Itinerary for a single day."""
    
    day: int = Field(
        ...,
        description="Day number in the trip",
        example=1,
        ge=1
    )
    date: str = Field(
        ...,
        description="Date in YYYY-MM-DD format",
        example="2024-03-15"
    )
    activities: List[Activity] = Field(
        ...,
        description="List of activities for the day",
        min_items=1
    )
    estimated_cost: Optional[float] = Field(
        None,
        description="Total estimated cost for the day in VND",
        example=500000.0
    )
    notes: Optional[str] = Field(
        None,
        description="Additional notes or recommendations for the day",
        example="Start early to avoid crowds at popular attractions"
    )
    
    @validator("date")
    def validate_date_format(cls, v):
        """Validate date format."""
        try:
            datetime.strptime(v, "%Y-%m-%d")
            return v
        except ValueError:
            raise ValueError("Date must be in YYYY-MM-DD format")
    
    @validator("estimated_cost")
    def validate_estimated_cost(cls, v):
        """Validate estimated cost is non-negative."""
        if v is not None and v < 0:
            raise ValueError("Estimated cost cannot be negative")
        return v


class TravelRequest(BaseModel):
    """Request schema for travel itinerary generation."""
    
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
        description="User preferences and interests",
        example=["food", "culture", "history"]
    )
    budget_range: Optional[str] = Field(
        None,
        description="Budget range category",
        example="medium"
    )
    group_size: Optional[int] = Field(
        default=2,
        description="Number of travelers",
        example=2,
        ge=1,
        le=20
    )
    travel_style: Optional[str] = Field(
        default="balanced",
        description="Travel style preference",
        example="adventurous"
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
    
    @validator("budget_range")
    def validate_budget_range(cls, v):
        """Validate budget range."""
        if v is not None:
            valid_ranges = {"low", "budget", "medium", "moderate", "high", "luxury"}
            if v.lower() not in valid_ranges:
                raise ValueError(f"Budget range must be one of: {', '.join(valid_ranges)}")
            return v.lower()
        return v
    
    @validator("travel_style")
    def validate_travel_style(cls, v):
        """Validate travel style."""
        if v is not None:
            valid_styles = {
                "relaxed", "balanced", "active", "adventurous", "cultural",
                "luxury", "budget", "family", "romantic", "solo", "backpacker"
            }
            if v.lower() not in valid_styles:
                raise ValueError(f"Travel style must be one of: {', '.join(valid_styles)}")
            return v.lower()
        return v
    
    @property
    def duration_days(self) -> int:
        """Calculate trip duration in days."""
        return (self.end_date - self.start_date).days + 1


class TravelResponse(BaseModel):
    """Response schema for generated travel itinerary."""
    
    destination: str = Field(
        ...,
        description="Destination name",
        example="Ho Chi Minh City"
    )
    total_days: int = Field(
        ...,
        description="Total number of days in the itinerary",
        example=4
    )
    itinerary: List[DayItinerary] = Field(
        ...,
        description="Day-by-day itinerary",
        min_items=1
    )
    total_estimated_cost: Optional[float] = Field(
        None,
        description="Total estimated cost for the entire trip in VND",
        example=2000000.0
    )
    recommendations: List[str] = Field(
        default_factory=list,
        description="General travel recommendations and tips",
        example=[
            "Try local street food in District 1",
            "Book Cu Chi Tunnels tour in advance"
        ]
    )
    weather_info: Optional[str] = Field(
        None,
        description="Weather information for the travel period",
        example="Expect warm and humid weather with occasional rain"
    )
    generated_at: datetime = Field(
        default_factory=datetime.utcnow,
        description="Timestamp when itinerary was generated"
    )
    
    @validator("total_estimated_cost")
    def validate_total_cost(cls, v):
        """Validate total estimated cost is non-negative."""
        if v is not None and v < 0:
            raise ValueError("Total estimated cost cannot be negative")
        return v


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


class DestinationInfo(BaseModel):
    """Information about a travel destination."""
    
    name: str = Field(..., example="Ho Chi Minh City")
    region: str = Field(..., example="South")
    description: str = Field(..., example="Vibrant metropolis with rich history")
    coordinates: Optional[dict] = Field(
        None,
        example={"lat": 10.8231, "lng": 106.6297}
    )
    best_time_to_visit: Optional[str] = Field(
        None,
        example="December to April (dry season)"
    )
    average_temperature: Optional[str] = Field(
        None,
        example="26-30°C"
    )


class VectorSearchResult(BaseModel):
    """Result from vector similarity search."""
    
    content: str = Field(..., description="Original content")
    similarity_score: float = Field(..., description="Similarity score (0-1)")
    metadata: dict = Field(default_factory=dict, description="Additional metadata")


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
    "Activity",
    "DayItinerary", 
    "TravelRequest",
    "TravelResponse",
    "HealthCheckResponse",
    "ErrorResponse",
    "DestinationInfo",
    "VectorSearchResult",
    "DataInsertRequest",
    "DataInsertResponse",
    "DataDeleteRequest",
    "DataDeleteResponse",
    "DataBatchUploadResponse",
]