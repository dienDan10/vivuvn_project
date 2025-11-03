"""
Weather agent for fetching weather forecasts.

Handles:
- Fetching weather data from OpenWeather API
- Extracting coordinates from places
- Building weather context for trip
"""

import structlog

from app.core.config import settings
from app.clients.openweather_client import OpenWeatherAPIClient
from app.services.weather_service import WeatherService
from app.agents.state import TravelPlanningState

logger = structlog.get_logger(__name__)


class WeatherAgent:
    """Agent responsible for fetching weather data."""

    def __init__(self):
        """Initialize weather agent."""
        weather_client = OpenWeatherAPIClient(
            api_key=settings.OPENWEATHER_API_KEY,
            base_url=settings.OPENWEATHER_BASE_URL,
            timeout=settings.OPENWEATHER_TIMEOUT,
            max_concurrent=settings.OPENWEATHER_MAX_CONCURRENT
        )
        self.weather_service = WeatherService(weather_client)

    async def fetch_weather_data(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 3: Fetch weather forecast for trip dates."""
        logger.info("[Node 3/6] Fetching weather data")

        try:
            relevant_places = state.get("relevant_places", [])
            if not relevant_places:
                logger.warning("No places available for weather coordinates")
                state["weather_fetched"] = False
                return state

            # Use first place coordinates (Vietnam provinces are small, weather is uniform)
            first_place = relevant_places[0]
            metadata = first_place.get("metadata", {})
            lat = metadata.get("latitude")
            lon = metadata.get("longitude")

            if lat is None or lon is None:
                logger.warning("First place missing coordinates")
                state["weather_fetched"] = False
                return state

            # Get trip dates and destination
            travel_request = state["travel_request"]
            start_date = travel_request.start_date
            end_date = travel_request.end_date
            destination = travel_request.destination

            # Fetch weather forecast
            weather_forecast = await self.weather_service.get_forecast_for_trip(
                lat=lat,
                lon=lon,
                start_date=start_date,
                end_date=end_date,
                destination=destination
            )

            state["weather_forecast"] = weather_forecast
            state["weather_fetched"] = weather_forecast is not None

            if weather_forecast:
                logger.info(
                    f"[Node 3/6] Weather fetched: {len(weather_forecast.daily_forecasts)} days"
                )
            else:
                logger.warning("[Node 3/6] Weather fetch failed, continuing without weather")

        except Exception as e:
            logger.error(f"[Node 3/6] Error fetching weather: {e}")
            state["weather_fetched"] = False

        return state


__all__ = ["WeatherAgent"]
