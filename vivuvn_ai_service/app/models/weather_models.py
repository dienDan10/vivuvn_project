"""
Weather data models for OpenWeather API integration.

Models match OpenWeather One Call API 3.0 Daily Aggregation endpoint response structure.
"""

from typing import List
from pydantic import BaseModel, Field


class WeatherTemperature(BaseModel):
    """Temperature data for a single day."""

    min: float = Field(..., description="Minimum temperature (°C)")
    max: float = Field(..., description="Maximum temperature (°C)")
    afternoon: float = Field(..., description="Temperature at 12:00 UTC (°C)")
    night: float = Field(..., description="Temperature at 00:00 UTC (°C)")
    evening: float = Field(..., description="Temperature at 18:00 UTC (°C)")
    morning: float = Field(..., description="Temperature at 06:00 UTC (°C)")


class WeatherPrecipitation(BaseModel):
    """Precipitation data for a single day."""

    total: float = Field(..., description="Total liquid water equivalent (mm)")


class WeatherWindMax(BaseModel):
    """Maximum wind data for a single day."""

    speed: float = Field(..., description="Maximum wind speed (m/s)")
    direction: float = Field(..., description="Wind direction in degrees (0-360)")


class WeatherWind(BaseModel):
    """Wind data container."""

    max: WeatherWindMax = Field(..., description="Maximum wind for the day")


class WeatherCloudCover(BaseModel):
    """Cloud cover data for a single day."""

    afternoon: float = Field(..., description="Cloud coverage at 12:00 UTC (%)")


class WeatherHumidity(BaseModel):
    """Humidity data for a single day."""

    afternoon: float = Field(..., description="Humidity at 12:00 UTC (%)")


class WeatherPressure(BaseModel):
    """Atmospheric pressure data for a single day."""

    afternoon: float = Field(..., description="Pressure at 12:00 UTC (hPa)")


class DailyWeatherData(BaseModel):
    """Complete weather data for a single day from OpenWeather API."""

    lat: float = Field(..., description="Latitude")
    lon: float = Field(..., description="Longitude")
    tz: str = Field(..., description="Timezone offset (±XX:XX)")
    date: str = Field(..., description="Date in YYYY-MM-DD format")
    units: str = Field(..., description="Units system (metric/imperial/standard)")
    temperature: WeatherTemperature = Field(..., description="Temperature data")
    precipitation: WeatherPrecipitation = Field(..., description="Precipitation data")
    cloud_cover: WeatherCloudCover = Field(..., description="Cloud cover data")
    humidity: WeatherHumidity = Field(..., description="Humidity data")
    pressure: WeatherPressure = Field(..., description="Atmospheric pressure data")
    wind: WeatherWind = Field(..., description="Wind data")


class WeatherForecast(BaseModel):
    """Weather forecast for an entire trip."""

    destination: str = Field(..., description="Province/city name")
    daily_forecasts: List[DailyWeatherData] = Field(
        ...,
        description="Daily weather forecasts for each day of the trip"
    )

    class Config:
        """Pydantic config."""
        json_schema_extra = {
            "example": {
                "destination": "Hà Nội",
                "daily_forecasts": [
                    {
                        "lat": 21.0285,
                        "lon": 105.8542,
                        "tz": "+07:00",
                        "date": "2025-12-25",
                        "units": "metric",
                        "temperature": {
                            "min": 18.5,
                            "max": 25.3,
                            "afternoon": 24.0,
                            "night": 19.0,
                            "evening": 22.0,
                            "morning": 20.0
                        },
                        "precipitation": {
                            "total": 0.0
                        },
                        "cloud_cover": {
                            "afternoon": 20
                        },
                        "humidity": {
                            "afternoon": 65
                        },
                        "pressure": {
                            "afternoon": 1015
                        },
                        "wind": {
                            "max": {
                                "speed": 5.5,
                                "direction": 90
                            }
                        }
                    }
                ]
            }
        }
