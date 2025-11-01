"""
Itinerary generation agent using Google Gemini.

Handles:
- Building prompts with grounded data
- Calling Gemini API with structured output
- Converting response to structured itinerary
"""

import structlog
import asyncio

from google import genai
from google.genai import types

from app.core.config import settings
from app.core.exceptions import ItineraryGenerationError
from app.models.travel_models import TravelItinerary
from app.prompts.travel_prompts import create_user_prompt, get_system_prompt_for_request
from app.agents.state import TravelPlanningState

logger = structlog.get_logger(__name__)


class ItineraryAgent:
    """Agent responsible for generating travel itineraries with LLM."""

    def __init__(self):
        """Initialize itinerary generation agent."""
        # Initialize Google AI client
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)
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

            # Call Gemini with structured output
            response = await asyncio.get_event_loop().run_in_executor(
                None,
                lambda: self.client.models.generate_content(
                    model=self.model,
                    config=request_config,
                    contents=user_prompt
                )
            )

            logger.info(response)

            # Get structured data directly from parsed response
            if not response.parsed:
                logger.error(f"[Node 4/6] No parsed response from Gemini")
                if response.text:
                    logger.error(f"[Node 4/6] Raw response: {response.text[:500]}...")
                raise ItineraryGenerationError("No structured response from Gemini")

            structured_itinerary: TravelItinerary = response.parsed

            # Convert to dictionary format for compatibility
            structured_data = {
                "days": [day.model_dump() for day in structured_itinerary.days],
                "transportation_suggestions": [t.model_dump() for t in structured_itinerary.transportation_suggestions],
                "total_cost": structured_itinerary.total_cost,
                "schedule_unavailable": structured_itinerary.schedule_unavailable,
                "unavailable_reason": structured_itinerary.unavailable_reason
            }

            # Log budget validation status
            if structured_data.get('schedule_unavailable'):
                logger.warning(f"[Node 4/6] ⚠️ Budget exceeded: {structured_data.get('unavailable_reason', 'No reason provided')}")
            else:
                logger.info(f"[Node 4/6] ✅ Budget OK: {structured_data.get('total_cost', 0):,.0f} VND")

            state["structured_itinerary"] = structured_data
            return state

        except Exception as e:
            logger.error(f"[Node 4/6] Failed: {e}")
            state["error"] = f"Generation failed: {str(e)}"
            return state


__all__ = ["ItineraryAgent"]
