"""
Travel planning API routes for ViVu Vietnam AI Service.

This module implements the REST API endpoints for travel itinerary generation
and related operations.
"""

import logging
from typing import Dict, Any, Optional
from datetime import datetime

from fastapi import APIRouter, HTTPException, Depends, BackgroundTasks
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from app.core.exceptions import (
    TravelPlanningError, 
    InvalidTravelRequestError,
    ItineraryGenerationError,
    ValidationError
)
from app.api.schemas import (
    TravelRequest, 
    TravelResponse, 
    ErrorResponse,
    DestinationInfo
)
from app.services.travel_agent import get_travel_agent
from app.services.ai_service import get_gemini_service
from app.services.vector_service import get_vector_service

logger = structlog.get_logger(__name__)

# Create router
router = APIRouter()


# Dependency to get travel agent
async def get_travel_planning_agent():
    """Dependency to get travel planning agent."""
    return get_travel_agent()


# Dependency to get AI service
async def get_ai_service():
    """Dependency to get AI service."""
    return get_gemini_service()


# Dependency to get vector service
async def get_vector_search_service():
    """Dependency to get vector service."""
    return get_vector_service()


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
    background_tasks: BackgroundTasks,
    travel_agent = Depends(get_travel_planning_agent),
    ai_service = Depends(get_ai_service)
):
    """
    Generate travel itinerary for Vietnam destinations.
    
    Args:
        travel_request: Travel planning request
        background_tasks: Background tasks for caching
        travel_agent: Travel planning agent
        ai_service: AI service for validation
        db: Database session
        
    Returns:
        TravelResponse: Generated travel itinerary
    """
    try:
        logger.info(
            "Travel itinerary generation started",
            destination=travel_request.destination,
            duration=travel_request.duration_days,
            preferences=travel_request.preferences
        )
        
        # Validate destination
        is_valid_destination = await ai_service.validate_destination(
            travel_request.destination
        )
        
        if not is_valid_destination:
            raise InvalidTravelRequestError(
                f"'{travel_request.destination}' is not a recognized destination in Vietnam",
                field="destination"
            )
        
        # # Check for existing cached itinerary
        # cache_key = _generate_cache_key(travel_request)
        # cached_itinerary = await _get_cached_itinerary(db, cache_key)
        
        # if cached_itinerary:
        #     logger.info("Returning cached itinerary", cache_key=cache_key)
        #     return _format_cached_response(cached_itinerary)
        
        # Generate new itinerary
        start_time = datetime.utcnow()
        travel_response = await travel_agent.plan_travel(travel_request)
        generation_time = int((datetime.utcnow() - start_time).total_seconds() * 1000)
        
        # Cache the generated itinerary in background
        background_tasks.add_task(
            # _cache_itinerary,
            # db,
            travel_request,
            travel_response,
            # cache_key,
            generation_time
        )
        
        logger.info(
            "Travel itinerary generated successfully",
            destination=travel_request.destination,
            generation_time_ms=generation_time,
            total_days=travel_response.total_days
        )
        
        return travel_response
        
    except InvalidTravelRequestError as e:
        logger.warning("Invalid travel request", error=str(e))
        raise HTTPException(status_code=400, detail=str(e))
        
    except ItineraryGenerationError as e:
        logger.error("Itinerary generation failed", error=str(e))
        raise HTTPException(status_code=500, detail=str(e))
        
    except TravelPlanningError as e:
        logger.error("Travel planning error", error=str(e))
        raise HTTPException(status_code=500, detail=str(e))
        
    except Exception as e:
        logger.error("Unexpected error in itinerary generation", error=str(e), exc_info=True)
        raise HTTPException(
            status_code=500, 
            detail="An unexpected error occurred while generating your itinerary"
        )


@router.get(
    "/destinations/search",
    response_model=list[DestinationInfo],
    summary="Search Destinations",
    description="Search for Vietnam destinations using semantic search"
)
async def search_destinations(
    query: str,
    limit: int = 10,
    vector_service = Depends(get_vector_search_service)
):
    """
    Search for Vietnam destinations.
    
    Args:
        query: Search query for destinations
        limit: Maximum number of results
        vector_service: Vector search service
        
    Returns:
        List[DestinationInfo]: Matching destinations
    """
    try:
        if not query or len(query.strip()) < 2:
            raise ValidationError("Query must be at least 2 characters long", field="query")
        
        destinations = await vector_service.search_destinations(
            query_text=query.strip(),
            limit=min(limit, 20)  # Cap at 20 results
        )
        
        # Format destinations for response
        formatted_destinations = []
        for dest in destinations:
            formatted_destinations.append(DestinationInfo(
                name=dest.get("name", "Unknown"),
                region=dest.get("region", "Vietnam"),
                description=dest.get("description", ""),
                coordinates=dest.get("coordinates"),
                best_time_to_visit=None,  # Could be enhanced
                average_temperature=None   # Could be enhanced
            ))
        
        logger.info(f"Destination search returned {len(formatted_destinations)} results", query=query)
        return formatted_destinations
        
    except ValidationError as e:
        raise HTTPException(status_code=422, detail=str(e))
        
    except Exception as e:
        logger.error("Destination search failed", error=str(e), query=query)
        raise HTTPException(status_code=500, detail="Search failed")


@router.get(
    "/destinations/{destination_name}/activities",
    summary="Get Destination Activities",
    description="Get activities and attractions for a specific destination"
)
async def get_destination_activities(
    destination_name: str,
    preferences: str = None,
    limit: int = 20,
    vector_service = Depends(get_vector_search_service)
):
    """
    Get activities for a specific destination.
    
    Args:
        destination_name: Name of the destination
        preferences: Comma-separated preferences
        limit: Maximum number of results
        vector_service: Vector search service
        
    Returns:
        List: Activities and attractions
    """
    try:
        # Parse preferences
        preference_list = []
        if preferences:
            preference_list = [p.strip() for p in preferences.split(",") if p.strip()]
        
        # Build search query
        query = f"{destination_name} activities attractions"
        if preference_list:
            query += f" {' '.join(preference_list)}"
        
        activities = await vector_service.search_activities(
            query_text=query,
            preferences=preference_list,
            limit=min(limit, 50)
        )
        
        logger.info(
            f"Retrieved {len(activities)} activities for {destination_name}",
            destination=destination_name,
            preferences=preference_list
        )
        
        return {
            "destination": destination_name,
            "activities": activities,
            "total_count": len(activities)
        }
        
    except Exception as e:
        logger.error("Failed to get destination activities", error=str(e))
        raise HTTPException(status_code=500, detail="Failed to retrieve activities")


@router.post(
    "/travel/validate-request",
    summary="Validate Travel Request",
    description="Validate travel request parameters without generating itinerary"
)
async def validate_travel_request(
    travel_request: TravelRequest,
    ai_service = Depends(get_ai_service)
):
    """
    Validate travel request without generating itinerary.
    
    Args:
        travel_request: Travel request to validate
        ai_service: AI service for validation
        
    Returns:
        Dict: Validation results
    """
    try:
        # Validate destination
        is_valid_destination = await ai_service.validate_destination(
            travel_request.destination
        )
        
        validation_results = {
            "valid": True,
            "destination_valid": is_valid_destination,
            "duration_days": travel_request.duration_days,
            "issues": []
        }
        
        # Check for potential issues
        if not is_valid_destination:
            validation_results["issues"].append(
                f"'{travel_request.destination}' may not be a recognized destination in Vietnam"
            )
            validation_results["valid"] = False
        
        if travel_request.duration_days > 30:
            validation_results["issues"].append(
                "Trip duration is very long (over 30 days)"
            )
        
        if travel_request.duration_days < 1:
            validation_results["issues"].append(
                "Trip duration must be at least 1 day"
            )
        
        logger.info("Travel request validated", valid=validation_results["valid"])
        return validation_results
        
    except Exception as e:
        logger.error("Travel request validation failed", error=str(e))
        raise HTTPException(status_code=500, detail="Validation failed")


# Utility functions

# def _generate_cache_key(travel_request: TravelRequest) -> str:
#     """Generate cache key for travel request."""
#     import hashlib
    
#     # Create a string representation of key request parameters
#     key_data = (
#         travel_request.destination.lower(),
#         travel_request.start_date.isoformat(),
#         travel_request.end_date.isoformat(),
#         str(sorted(travel_request.preferences or [])),
#         travel_request.budget_range or "",
#         str(travel_request.group_size),
#         travel_request.travel_style or ""
#     )
    
#     key_string = "|".join(key_data)
#     return hashlib.md5(key_string.encode()).hexdigest()


# async def _get_cached_itinerary(
#     db: AsyncSession, 
#     cache_key: str
# ) -> Optional[TravelItinerary]:
#     """Get cached itinerary if available."""
#     try:
#         from sqlalchemy import select
        
#         result = await db.execute(
#             select(TravelItinerary).where(
#                 TravelItinerary.cache_key == cache_key,
#                 TravelItinerary.is_cached == True
#             )
#         )
        
#         return result.scalar_one_or_none()
        
#     except Exception as e:
#         logger.warning("Failed to retrieve cached itinerary", error=str(e))
#         return None


# def _format_cached_response(cached_itinerary: TravelItinerary) -> TravelResponse:
#     """Format cached itinerary as response."""
#     return TravelResponse(
#         destination=cached_itinerary.destination_name,
#         total_days=cached_itinerary.duration_days,
#         itinerary=cached_itinerary.itinerary_data.get("itinerary", []),
#         total_estimated_cost=cached_itinerary.total_estimated_cost,
#         recommendations=cached_itinerary.itinerary_data.get("recommendations", []),
#         weather_info=cached_itinerary.itinerary_data.get("weather_info"),
#         generated_at=cached_itinerary.created_at
#     )


# async def _cache_itinerary(
#     db: AsyncSession,
#     travel_request: TravelRequest,
#     travel_response: TravelResponse,
#     cache_key: str,
#     generation_time_ms: int
# ):
#     """Cache generated itinerary for future use."""
#     try:
#         async with db.begin():
#             cached_itinerary = TravelItinerary(
#                 destination_name=travel_request.destination,
#                 start_date=travel_request.start_date,
#                 end_date=travel_request.end_date,
#                 duration_days=travel_request.duration_days,
#                 preferences=travel_request.preferences,
#                 budget_range=travel_request.budget_range,
#                 group_size=travel_request.group_size,
#                 travel_style=travel_request.travel_style,
#                 itinerary_data=travel_response.dict(),
#                 total_estimated_cost=travel_response.total_estimated_cost,
#                 generation_time_ms=generation_time_ms,
#                 is_cached=True,
#                 cache_key=cache_key
#             )
            
#             db.add(cached_itinerary)
#             await db.commit()
            
#         logger.info("Itinerary cached successfully", cache_key=cache_key)
        
#     except Exception as e:
#         logger.warning("Failed to cache itinerary", error=str(e), cache_key=cache_key)


# Export router
__all__ = ["router"]