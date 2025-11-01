"""
Weather service for travel planning.

Business logic layer for weather data integration. Transforms raw API data
into structured forecasts and provides trip-specific weather information.
"""

import structlog
from datetime import date, timedelta
from typing import List, Optional

from app.clients.openweather_client import OpenWeatherAPIClient
from app.models.weather_models import WeatherForecast, DailyWeatherData

logger = structlog.get_logger(__name__)


class WeatherService:
    """Business logic for weather data integration."""

    def __init__(self, client: OpenWeatherAPIClient):
        """
        Initialize weather service.

        Args:
            client: OpenWeather API client instance
        """
        self.client = client

    async def get_forecast_for_trip(
        self,
        lat: float,
        lon: float,
        start_date: date,
        end_date: date,
        destination: str,
    ) -> Optional[WeatherForecast]:
        """
        Fetch weather forecast for entire trip.

        Args:
            lat: Latitude of destination
            lon: Longitude of destination
            start_date: Trip start date
            end_date: Trip end date
            destination: Province/city name

        Returns:
            WeatherForecast with daily forecasts or None if all API calls fail
        """
        try:
            # Generate list of dates
            dates = []
            current = start_date
            while current <= end_date:
                dates.append(current.isoformat())  # YYYY-MM-DD
                current += timedelta(days=1)

            logger.info(
                "Fetching weather for trip",
                destination=destination,
                dates=len(dates),
                start=start_date.isoformat(),
                end=end_date.isoformat(),
            )

            # Fetch all dates in parallel
            raw_results = await self.client.fetch_multiple_days(lat, lon, dates)

            # Transform to Pydantic models
            daily_forecasts = []
            for raw_data in raw_results:
                if raw_data is not None:
                    try:
                        forecast = DailyWeatherData(**raw_data)
                        daily_forecasts.append(forecast)
                    except Exception as e:
                        logger.error("Failed to parse weather data", error=str(e))

            if not daily_forecasts:
                logger.warning("No weather data available")
                return None

            logger.info(
                "Weather data fetched successfully",
                total_days=len(dates),
                successful_days=len(daily_forecasts),
            )

            return WeatherForecast(
                destination=destination, daily_forecasts=daily_forecasts
            )

        except Exception as e:
            logger.error("Weather service error", error=str(e))
            return None
