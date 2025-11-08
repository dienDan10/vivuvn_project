"""
Travel planning API routes for ViVu Vietnam AI Service.

This module implements the REST API endpoints for travel itinerary generation
and related operations.
"""

import structlog
from datetime import datetime
from fastapi import APIRouter, Depends

from app.api.schemas import (
    ErrorResponse,
    TravelRequest,
    TravelResponse
)
from app.agents import get_travel_agent

logger = structlog.get_logger(__name__)

router = APIRouter()


async def get_travel_planning_agent():
    """Dependency to get travel planning agent."""
    return get_travel_agent()


@router.post(
    "/travel/generate-itinerary",
    response_model=TravelResponse,
    responses={
        400: {"model": ErrorResponse, "description": "Invalid travel request"},
        422: {"model": ErrorResponse, "description": "Validation error"},
        500: {"model": ErrorResponse, "description": "Generation failed"},
        502: {"model": ErrorResponse, "description": "AI service error"}
    },
    summary="Generate Travel Itinerary",
    description="""
    Generate a comprehensive travel itinerary for Vietnam destinations using AI.
    
    The service uses RAG (Retrieval-Augmented Generation) pattern with:
    - Google Gemini AI for content generation
    - Vector search for relevant travel information
    - Cultural insights specific to Vietnam
    
    **Request Parameters:**
    - `destination`: Vietnam destination (required)
    - `start_date` & `end_date`: Travel dates (required)
    - `preferences`: Travel interests (optional)
    - `budget_range`: Budget category (optional)
    - `group_size`: Number of travelers (optional)
    - `travel_style`: Travel style preference (optional)
    
    **Response includes:**
    - Day-by-day detailed itinerary
    - Activity descriptions with times and locations
    - Cost estimates in Vietnamese Dong (VND)
    - Cultural recommendations and tips
    - Weather information
    """
)
async def generate_itinerary(
    travel_request: TravelRequest,
    travel_agent = Depends(get_travel_planning_agent)
):
    """
    Generate travel itinerary for Vietnam destinations.

    Args:
        travel_request: Travel planning request
        travel_agent: Travel planning agent

    Returns:
        TravelResponse: Generated travel itinerary
    """
    logger.info(
        "Travel itinerary generation started",
        destination=travel_request.destination,
        duration=travel_request.duration_days,
        preferences=travel_request.preferences
    )

    # Generate new itinerary
    start_time = datetime.now()
    travel_response = await travel_agent.plan_travel(travel_request)
    generation_time = int((datetime.now() - start_time).total_seconds() * 1000)

    logger.info(
        "Travel itinerary generated successfully",
        destination=travel_request.destination,
        generation_time_ms=generation_time,
    )

    return travel_response



# Export router
__all__ = ["router"]