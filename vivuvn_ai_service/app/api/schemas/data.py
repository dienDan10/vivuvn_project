"""Generic data management schemas (delete, batch upload)."""

from typing import Optional

from pydantic import BaseModel, Field


class DataDeleteResponse(BaseModel):
    """Response schema for data delete operations."""

    success: bool = Field(..., description="Operation success status")
    message: str = Field(..., description="Result message")
    item_id: str = Field(..., description="Deleted item ID (Google Place ID)")

__all__ = [
    "DataDeleteResponse",
]
