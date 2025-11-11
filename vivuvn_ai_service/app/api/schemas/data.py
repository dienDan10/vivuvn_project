"""Generic data management schemas (delete, batch upload)."""

from typing import Optional

from pydantic import BaseModel, Field


class DataDeleteRequest(BaseModel):
    """Request schema for deleting data items."""

    item_id: str = Field(
        ...,
        description="ID of item to delete (Google Place ID)",
        example="ChIJ3X2j5_4xejERIWPhzCKfDaQ"
    )


class DataDeleteResponse(BaseModel):
    """Response schema for data delete operations."""

    success: bool = Field(..., description="Operation success status")
    message: str = Field(..., description="Result message")
    item_id: str = Field(..., description="Deleted item ID (Google Place ID)")

__all__ = [
    "DataDeleteRequest",
    "DataDeleteResponse",
]
