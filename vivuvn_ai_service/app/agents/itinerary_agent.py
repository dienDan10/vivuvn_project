"""
Itinerary generation agent using Google Gemini.

Handles:
- Building prompts with grounded data
- Calling Gemini API with structured output
- Converting response to structured itinerary
- Retry logic for transient failures
"""

import asyncio
import json
import structlog

from google.genai import types
from google.api_core import exceptions as google_exceptions

from app.core.config import settings
from app.core.exceptions import (
    ItineraryGenerationError
)
from app.models.travel_models import TravelItinerary
from app.prompts.travel_prompts import create_user_prompt, get_system_prompt_for_request
from app.agents.state import TravelPlanningState
from app.clients.gemini_client import get_gemini_client

logger = structlog.get_logger(__name__)


class ItineraryAgent:
    """Agent responsible for generating travel itineraries with LLM."""

    def __init__(self):
        """Initialize itinerary generation agent."""
        # Get shared Gemini client (singleton)
        self.gemini_client = get_gemini_client()
        self.model = settings.GEMINI_MODEL

        # Base config (without system instruction, which varies per request)
        self.base_generation_config = {
            "response_mime_type": "application/json",
            "response_schema": TravelItinerary,
            "thinking_config": types.ThinkingConfig(thinking_budget=0),
            "temperature": settings.TEMPERATURE,
            "max_output_tokens": settings.MAX_TOKENS
        }


    async def generate_structured_itinerary(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 4: Generate itinerary with function calling."""
        try:
            travel_request = state["travel_request"]
            relevant_places = state.get("relevant_places", [])

            if not relevant_places:
                state["error"] = "No places available - cannot generate itinerary"
                return state

            logger.info(f"[Node 4/6] Generating with {len(relevant_places)} verified places")

            # Build user prompt with grounded data
            place_clusters = state.get("place_clusters", [])
            top_relevant_places = state.get("top_relevant_places", [])
            weather_forecast = state.get("weather_forecast")
            user_prompt = create_user_prompt(
                travel_request,
                relevant_places,
                place_clusters,
                top_relevant_places,
                weather_forecast
            )
            system_prompt = get_system_prompt_for_request(travel_request)

            # Create config with system instruction (extends base config)
            request_config = types.GenerateContentConfig(
                system_instruction=system_prompt,
                **self.base_generation_config
            )

            # Call Gemini with retry logic (handled by GeminiClient)
            response = await self.gemini_client.generate_content(request_config, user_prompt)

            # Parse structured response from Gemini
            structured_itinerary: TravelItinerary = None

            # Try to get parsed response first (preferred method)
            if hasattr(response, 'parsed') and response.parsed:
                structured_itinerary = response.parsed
            # Fallback: manually parse JSON from text response
            elif response.text:
                try:
                    parsed_data = json.loads(response.text)
                    structured_itinerary = TravelItinerary(**parsed_data)
                except (json.JSONDecodeError, TypeError, ValueError) as parse_error:
                    logger.error(
                        f"[Node 4/6] Failed to parse Gemini response",
                        error=str(parse_error),
                        raw_response=response.text
                    )
                    raise ItineraryGenerationError(f"Failed to parse itinerary JSON: {str(parse_error)}")
            else:
                logger.error(f"[Node 4/6] No response from Gemini")
                raise ItineraryGenerationError("No structured response from Gemini")

            if not structured_itinerary:
                raise ItineraryGenerationError("No structured response from Gemini")

            # Convert to dictionary format for compatibility
            structured_data = {
                "days": [day.model_dump() for day in structured_itinerary.days],
                "transportation_suggestions": [t.model_dump() for t in structured_itinerary.transportation_suggestions],
                "total_cost": structured_itinerary.total_cost,
                "schedule_unavailable": structured_itinerary.schedule_unavailable,
                "warnings": structured_itinerary.warnings
            }

            # Log budget validation status with structured fields
            if structured_data.get('schedule_unavailable'):
                warnings = structured_data.get('warnings', [])
                blocking_reason = warnings[0] if warnings else 'Không có lý do cụ thể'
                logger.warning(
                    "[Node 4/6] Lịch trình không khả dụng",
                    destination=travel_request.destination,
                    total_cost=structured_data.get('total_cost', 0),
                    budget=travel_request.budget,
                    reason=blocking_reason,
                    error_code="SCHEDULE_UNAVAILABLE"
                )
            else:
                logger.info(
                    "[Node 4/6] Itinerary generated successfully",
                    destination=travel_request.destination,
                    total_cost=structured_data.get('total_cost', 0),
                    num_days=len(structured_data.get('days', [])),
                    num_activities=sum(len(day.get('activities', [])) for day in structured_data.get('days', []))
                )

            state["structured_itinerary"] = structured_data
            return state

        except Exception as e:
            error_message = getattr(e, 'message', str(e))
            logger.error(
                "[Node 4/6] Itinerary generation failed",
                destination=travel_request.destination,
                error=error_message,
                error_code="GENERATION_FAILED",
                exc_info=True
            )
            state["error"] = error_message
            return state


__all__ = ["ItineraryAgent"]
