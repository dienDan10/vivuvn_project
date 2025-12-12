"""
State definition for LangGraph workflow.

This module defines the TypedDict state that flows through the workflow nodes.
"""

from typing import Dict, List, Any, Optional, TypedDict

from app.api.schemas import TravelRequest, TravelResponse
from app.models.weather_models import WeatherForecast


class TravelPlanningState(TypedDict):
    """Workflow state with validation flags."""
    travel_request: TravelRequest
    search_filters: Dict[str, Any]
    relevant_places: List[Dict[str, Any]]
    place_clusters: List[List[Dict[str, Any]]]  # Geographical clusters
    top_relevant_places: List[Dict[str, Any]]  # Top places by Pinecone score (for descriptions)
    weather_forecast: Optional[WeatherForecast]  # Weather data for trip
    weather_fetched: bool  # Whether weather fetch succeeded
    structured_itinerary: Optional[Dict[str, Any]]
    final_response: Optional[TravelResponse]
    error: Optional[str]
    validation_passed: bool  # Anti-hallucination check
    warnings: List[str]  # Warnings from both LLM and backend


__all__ = ["TravelPlanningState"]
