"""Travel itinerary related API schemas."""

from datetime import date
from typing import List, Optional

from pydantic import BaseModel, Field, field_validator, ValidationInfo

# Import travel models from dedicated module
from app.models.travel_models import (
    Activity,
    DayItinerary,
    TravelItinerary,
    TransportationSuggestion,
)


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
        description="List of travel preferences (Vietnamese categories)",
        example=["ẩm thực", "văn hóa", "thiên nhiên"]
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
    transportation_mode: Optional[str] = Field(
        None,
        description="Preferred mode of transportation",
        example="xe khách"
    )

    @field_validator("end_date")
    @classmethod
    def validate_date_range(cls, v, info: ValidationInfo):
        """Validate that end_date is after start_date."""
        if info.data.get("start_date") and v <= info.data["start_date"]:
            raise ValueError("End date must be after start date")
        return v

    @field_validator("preferences")
    @classmethod
    def validate_preferences(cls, v):
        """Validate preference categories in Vietnamese."""
        valid_preferences = {
            "văn hóa", "lịch sử", "thiên nhiên", "nhiếp ảnh", "ẩm thực",
            "mua sắm", "phiêu lưu", "thư giãn", "đời sống về đêm"
        }
        for pref in v:
            if pref.lower() not in valid_preferences:
                raise ValueError(f"Invalid preference: {pref}")
        return [pref.lower() for pref in v]

    @field_validator("budget")
    @classmethod
    def validate_budget(cls, v):
        """Validate budget."""
        if v is not None:
            if v < 0:
                raise ValueError("Budget cannot be negative")
            return v
        return v

    @field_validator("transportation_mode")
    @classmethod
    def validate_transportation_mode(cls, v):
        """Validate transportation mode."""
        valid_modes = {"xe khách", "tàu hỏa", "máy bay", "ô tô cá nhân", "xe máy"}
        if v is not None and v.lower() not in valid_modes:
            raise ValueError(f"Invalid transportation mode: {v}")
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


__all__ = [
    "TravelRequest",
    "TravelResponse",
    # Re-export models for convenience
    "Activity",
    "DayItinerary",
    "TravelItinerary",
    "TransportationSuggestion",
]
