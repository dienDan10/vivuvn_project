"""
Data management API routes for ViVu Vietnam AI Service.

This module provides endpoints for managing travel data in Pinecone vector database.
"""

import structlog
from fastapi import APIRouter

from app.api.schemas.place import PlaceUpsertRequest, PlaceUpsertResponse
from app.services.data_management_service import get_data_management_service
from app.api.schemas import (
    PlaceInsertRequest,
    PlaceInsertResponse,
    PlaceUpdateRequest,
    PlaceUpdateResponse,
    DataDeleteRequest,
    DataDeleteResponse,
)

logger = structlog.get_logger(__name__)

router = APIRouter()


@router.post("/place/insert", response_model=PlaceUpsertResponse)
async def insert_place(request: PlaceUpsertRequest):
    """
    Insert or upsert a single place in Pinecone using optimized embedding service.

    Uses Pinecone's upsert operation which automatically handles:
    - Inserting new places
    - Overwriting existing places (if googlePlaceId already exists)

    Args:
        request: Place data to insert

    Returns:
        PlaceInsertResponse: Success status and place ID
    """
    place_name = request.place.name
    place_id = request.place.googlePlaceId

    logger.info(f"Inserting place", place_name=place_name, place_id=place_id)

    dm_service = get_data_management_service()

    # Convert PlaceData to dict for service
    place_dict = request.place.model_dump()

    success = await dm_service.upsert_place(place_data=place_dict)

    if not success:
        raise ValueError(f"Failed to insert place: {place_name}")

    logger.info(f"Successfully inserted place", place_id=place_id, place_name=place_name)

    return PlaceInsertResponse(
        success=True,
        message=f"Successfully inserted place: {place_name}",
        place_id=place_id
    )


@router.put("/place/update", response_model=PlaceUpsertResponse)
async def update_place(request: PlaceUpsertRequest):
    """
    Update a single place in Pinecone using upsert operation.

    Uses Pinecone's upsert operation which automatically overwrites existing vectors
    if the googlePlaceId already exists in the database.

    Args:
        request: Updated place data

    Returns:
        PlaceUpdateResponse: Success status and place ID
    """
    place_name = request.place.name
    place_id = request.place.googlePlaceId

    logger.info(f"Updating place", place_name=place_name, place_id=place_id)

    dm_service = get_data_management_service()

    # Convert PlaceData to dict for service
    place_dict = request.place.model_dump()

    # Use upsert_place which automatically handles updates via Pinecone's upsert
    success = await dm_service.upsert_place(place_data=place_dict)

    if not success:
        raise ValueError(f"Failed to update place: {place_name}")

    logger.info(f"Successfully updated place", place_id=place_id, place_name=place_name)

    return PlaceUpdateResponse(
        success=True,
        message=f"Successfully updated place: {place_name}",
        place_id=place_id
    )


@router.delete("/place/delete", response_model=DataDeleteResponse)
async def delete_data_item(request: DataDeleteRequest):
    """
    Delete a data item from Pinecone by ID.

    Args:
        request: Item ID to delete

    Returns:
        DataDeleteResponse: Success status
    """
    logger.info(f"Deleting item {request.item_id}", item_id=request.item_id)

    dm_service = get_data_management_service()
    success = await dm_service.delete_place(request.item_id)

    if not success:
        raise ValueError(f"Item {request.item_id} not found or could not be deleted")

    logger.info(f"Successfully deleted item {request.item_id}", item_id=request.item_id)

    return DataDeleteResponse(
        success=True,
        message=f"Successfully deleted item {request.item_id}",
        item_id=request.item_id
    )