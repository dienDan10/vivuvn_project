"""Place-related API schemas with comprehensive validation."""

from pydantic import BaseModel, Field, field_validator


class PlaceUpsertRequest(BaseModel):
    """Request schema for upserting a place."""

    name: str = Field(
        ...,
        description="Place name",
        example="Hoan Kiem Lake",
        min_length=1,
        max_length=200
    )
    googlePlaceId: str = Field(
        ...,
        description="Google Place ID for identification",
        example="ChIJ3X2j5_4xejERIWPhzCKfDaQ",
        min_length=1
    )
    description: str = Field(
        ...,
        description="Detailed description of the place (will be chunked for embedding)",
        example="Historic lake in the center of Hanoi...",
        min_length=10
    )
    address: str = Field(
        ...,
        description="Full address of the place",
        example="Hang Dau St, Hoan Kiem District, Hanoi 100000, Vietnam",
        min_length=5
    )
    latitude: float = Field(
        ...,
        description="Geographic latitude",
        example=21.0285,
        ge=-90.0,
        le=90.0
    )
    longitude: float = Field(
        ...,
        description="Geographic longitude",
        example=105.8537,
        ge=-180.0,
        le=180.0
    )
    rating: float = Field(
        ...,
        description="Rating from 0.0 to 5.0",
        example=4.8,
        ge=0.0,
        le=5.0
    )
    province: str = Field(
        ...,
        description="Province or city name",
        example="Hà Nội",
        min_length=1,
        max_length=100
    )

    @field_validator("name")
    @classmethod
    def validate_name(cls, v):
        """Validate place name is not empty."""
        if not v or not v.strip():
            raise ValueError("Place name cannot be empty")
        return v.strip()

    @field_validator("description")
    @classmethod
    def validate_description(cls, v):
        """Validate description has minimum content."""
        if not v or len(v.strip()) < 10:
            raise ValueError("Description must be at least 10 characters")
        return v.strip()

    @field_validator("googlePlaceId")
    @classmethod
    def validate_place_id(cls, v):
        """Validate Google Place ID format."""
        if not v or not v.strip():
            raise ValueError("googlePlaceId is required")
        return v.strip()

    class Config:
        """Pydantic config."""
        json_schema_extra = {
            "example": {
                "name": "Hoan Kiem Lake",
                "googlePlaceId": "ChIJ3X2j5_4xejERIWPhzCKfDaQ",
                "description": "Historic lake in the center of Hanoi, Vietnam. A popular tourist destination.",
                "address": "Hang Dau St, Hoan Kiem District, Hanoi 100000, Vietnam",
                "latitude": 21.0285,
                "longitude": 105.8537,
                "rating": 4.8,
                "province": "Hà Nội"
            }
        }


class PlaceUpsertResponse(BaseModel):
    """Response schema for place upsert operations."""

    success: bool = Field(..., description="Operation success status")
    message: str = Field(..., description="Result message")
    place_id: str = Field(..., description="Google Place ID of upserted place")


__all__ = [
    "PlaceUpsertRequest",
    "PlaceUpsertResponse",
]
