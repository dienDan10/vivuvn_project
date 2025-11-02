"""
OpenWeather API client for weather data fetching.

Low-level HTTP client for OpenWeather One Call API 3.0 - Daily Aggregation endpoint.
Handles HTTP communication, error handling, retries, and rate limiting.
"""

import asyncio
from typing import List, Optional

import httpx
import structlog

logger = structlog.get_logger(__name__)


class OpenWeatherAPIClient:
    """Low-level HTTP client for OpenWeather API."""

    def __init__(
        self,
        api_key: str,
        base_url: str = "https://api.openweathermap.org/data/3.0",
        timeout: float = 30.0,
        max_concurrent: int = 10,
    ):
        """
        Initialize OpenWeather API client.

        Args:
            api_key: OpenWeather API key
            base_url: Base URL for OpenWeather API
            timeout: Request timeout in seconds
            max_concurrent: Maximum concurrent requests
        """
        self.api_key = api_key
        self.base_url = base_url
        self.timeout = httpx.Timeout(timeout)
        self.limits = httpx.Limits(max_connections=100, max_keepalive_connections=20)
        self.semaphore = asyncio.Semaphore(max_concurrent)

    async def fetch_day_summary(
        self, client: httpx.AsyncClient, lat: float, lon: float, date: str
    ) -> Optional[dict]:
        """
        Fetch weather summary for a single date.

        Args:
            client: Async HTTP client instance
            lat: Latitude (-90 to 90)
            lon: Longitude (-180 to 180)
            date: Date in YYYY-MM-DD format

        Returns:
            Raw JSON response dict or None on error
        """
        async with self.semaphore:
            url = f"{self.base_url}/onecall/day_summary"
            params = {
                "lat": lat,
                "lon": lon,
                "date": date,
                "appid": self.api_key,
                "units": "metric",  # Celsius
                "lang": "vi",  # Vietnamese
            }

            for attempt in range(3):
                try:
                    logger.info(
                        "Fetching weather",
                        lat=lat,
                        lon=lon,
                        date=date,
                        attempt=attempt + 1,
                    )
                    response = await client.get(url, params=params)

                    if response.status_code == 200:
                        return response.json()

                    elif response.status_code == 401:
                        logger.error("Invalid API key")
                        from app.core.exceptions import AuthenticationError

                        raise AuthenticationError("Invalid OpenWeather API key")

                    elif response.status_code == 429:
                        if attempt < 2:
                            wait_time = 2**attempt
                            logger.warning(
                                "Rate limit exceeded, retrying", wait_time=wait_time
                            )
                            await asyncio.sleep(wait_time)
                            continue
                        logger.error("Rate limit exceeded, max retries reached")
                        return None

                    elif response.status_code == 404:
                        logger.warning("Weather data not found", date=date)
                        return None

                    elif response.status_code >= 500:
                        if attempt < 2:
                            wait_time = 2**attempt
                            logger.warning(
                                "Server error, retrying",
                                status=response.status_code,
                                wait_time=wait_time,
                            )
                            await asyncio.sleep(wait_time)
                            continue
                        logger.error(
                            "Server error, max retries reached",
                            status=response.status_code,
                        )
                        return None

                    else:
                        logger.error("Unexpected status code", status=response.status_code)
                        return None

                except httpx.RequestError as e:
                    if attempt < 2:
                        wait_time = 2**attempt
                        logger.warning(
                            "Request failed, retrying", error=str(e), wait_time=wait_time
                        )
                        await asyncio.sleep(wait_time)
                        continue
                    logger.error("Request failed, max retries reached", error=str(e))
                    return None

            return None

    async def fetch_multiple_days(
        self, lat: float, lon: float, dates: List[str]
    ) -> List[Optional[dict]]:
        """
        Fetch weather for multiple dates in parallel.

        Args:
            lat: Latitude (-90 to 90)
            lon: Longitude (-180 to 180)
            dates: List of dates in YYYY-MM-DD format

        Returns:
            List of raw JSON response dicts (None for failed requests)
        """
        async with httpx.AsyncClient(
            timeout=self.timeout, limits=self.limits
        ) as client:
            tasks = [self.fetch_day_summary(client, lat, lon, date) for date in dates]
            results = await asyncio.gather(*tasks, return_exceptions=True)

            # Handle exceptions
            processed_results = []
            for i, result in enumerate(results):
                if isinstance(result, Exception):
                    logger.error("Task failed", date=dates[i], error=str(result))
                    processed_results.append(None)
                else:
                    processed_results.append(result)

            return processed_results
