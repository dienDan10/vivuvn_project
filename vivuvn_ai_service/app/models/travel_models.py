"""
Pydantic models for travel itinerary generation.

This module defines the structured output models used by the travel planning AI
to ensure consistent and validated response formats.
"""

from typing import List, Optional
from pydantic import BaseModel, Field, field_validator


class Activity(BaseModel):
    """Individual activity within a day's itinerary.

    All activities MUST reference a database place with a valid place_id.
    Generic activities (meals, breaks, transport) should not be included.
    """

    time: str = Field(
        ...,
        description="Start time in HH:MM format (e.g., 09:00)"
    )
    name: str = Field(
        ...,
        description="Activity name - must match database place name exactly"
    )
    place_id: str = Field(
        ...,
        description="Google Place ID from database (required foreign key)"
    )
    duration_hours: float = Field(
        ...,
        description="Duration in hours (e.g., 2.0, 0.5, 1.5). Minimum 0.5h, maximum 8.0h",
        ge=0.5,
        le=8.0
    )
    cost_estimate: float = Field(
        ...,
        description="Estimated cost in VND (0 for free activities)",
        ge=0
    )
    category: str = Field(
        ...,
        description="Activity category (must match predefined categories)",
        pattern="^(food|sightseeing|culture|history|nature|adventure|shopping|entertainment|relaxation)$"
    )
    
    @field_validator("time")
    @classmethod
    def validate_time_format(cls, v):
        """Validate time format (HH:MM)."""
        try:
            hour, minute = map(int, v.split(":"))
            if not (0 <= hour <= 23 and 0 <= minute <= 59):
                raise ValueError("Invalid time range")
            return v
        except (ValueError, AttributeError):
            raise ValueError("Time must be in HH:MM format")
    
    @field_validator("category")
    @classmethod
    def validate_category(cls, v):
        """Validate activity category (removed 'transportation' - not allowed)."""
        valid_categories = {
            "food", "sightseeing", "culture", "history", "nature",
            "adventure", "shopping", "entertainment", "relaxation"
        }
        if v.lower() not in valid_categories:
            raise ValueError(f"Category must be one of: {', '.join(valid_categories)}")
        return v.lower()

    @field_validator("duration_hours")
    @classmethod
    def validate_duration(cls, v):
        """Validate duration is reasonable (0.5-8 hours for a single activity)."""
        if v > 8.0:
            raise ValueError("Single activity duration cannot exceed 8 hours")
        if v < 0.5:
            raise ValueError("Duration must be at least 0.5 hours (30 minutes)")
        return v


class DayItinerary(BaseModel):
    """Itinerary for a single day."""
    
    day: int = Field(
        ..., 
        description="Day number (1, 2, 3...)",
        ge=1
    )
    date: str = Field(
        ..., 
        description="Date in YYYY-MM-DD format",
        pattern=r"^\d{4}-\d{2}-\d{2}$"
    )
    activities: List[Activity] = Field(
        ..., 
        description="List of activities for the day",
        min_items=1
    )
    estimated_cost: Optional[float] = Field(
        None,
        description="Total estimated cost for the day in VND"
    )
    notes: str = Field(
        ..., 
        description="Daily tips and recommendations"
    )
    
    @field_validator("date")
    @classmethod
    def validate_date_format(cls, v):
        """Validate date format."""
        from datetime import datetime
        try:
            datetime.strptime(v, "%Y-%m-%d")
            return v
        except ValueError:
            raise ValueError("Date must be in YYYY-MM-DD format")
    
    @field_validator("estimated_cost")
    @classmethod
    def validate_estimated_cost(cls, v):
        """Validate estimated cost is non-negative."""
        if v is not None and v < 0:
            raise ValueError("Estimated cost cannot be negative")
        return v

class TransportationSuggestion(BaseModel):
    """Transportation suggestion for inter-city travel.

    Used for long-distance travel between cities/provinces, not for
    activities within a destination (those go in activities array).
    """

    mode: str = Field(
        ...,
        description="Mode of transportation: máy bay, xe khách, tàu hỏa, ô tô cá nhân",
        pattern="^(máy bay|xe khách|tàu hỏa|ô tô cá nhân)$"
    )
    estimated_cost: float = Field(
        ...,
        description="Estimated cost in VND (total for group if applicable)",
        ge=0
    )
    date: str = Field(
        ...,
        description="Date of travel in YYYY-MM-DD format",
        pattern=r"^\d{4}-\d{2}-\d{2}$"
    )
    details: str = Field(
        ...,
        description="Route and additional details (e.g., 'Hà Nội → Đà Nẵng, chuyến sáng 07:00-08:30')"
    )

    @field_validator("mode")
    @classmethod
    def validate_mode(cls, v):
        """Validate transportation mode."""
        valid_modes = {"máy bay", "xe khách", "tàu hỏa", "ô tô cá nhân"}
        if v not in valid_modes:
            raise ValueError(f"Mode must be one of: {', '.join(valid_modes)}")
        return v


class TravelItinerary(BaseModel):
    """Complete travel itinerary response."""
    
    days: List[DayItinerary] = Field(
        ..., 
        description="List of daily itineraries",
        min_items=1
    )
    transportation_suggestions: List[TransportationSuggestion] = Field(
        ..., 
        description="Transportation suggestions from origin to destination and vice versa",
        min_items=0,
        max_items=2
    )
    total_cost: float = Field(
        ..., 
        description="Total trip cost in VND",
        ge=0
    )
    schedule_unavailable: bool = Field(
        ...,
        description="True if itinerary could not be fully scheduled due to constraints"
    )
    unavailable_reason: str = Field(
        ...,
        description="Reason why itinerary could not be fully scheduled, if applicable"
    )


__all__ = ["Activity", "DayItinerary", "TravelItinerary", "TransportationSuggestion"]