"""
Weather helper utilities for travel planning.

Provides formatting and utility functions for weather data integration.
"""

from typing import Optional
from app.models.weather_models import WeatherForecast


def format_weather_for_prompt(weather_forecast: Optional[WeatherForecast]) -> str:
    """
    Format weather forecast for Gemini AI prompt (Vietnamese).

    Args:
        weather_forecast: Weather forecast data or None

    Returns:
        Formatted Vietnamese weather string for AI prompt, or empty string if no data
    """
    if not weather_forecast or not weather_forecast.daily_forecasts:
        return ""

    lines = ["THÔNG TIN THỜI TIẾT:"]

    for i, day in enumerate(weather_forecast.daily_forecasts, 1):
        temp_min = day.temperature.min
        temp_max = day.temperature.max
        rain = day.precipitation.total

        # Determine weather condition and guidance (Vietnamese)
        if rain > 10:
            condition = "Mưa lớn - Ưu tiên hoạt động trong nhà"
        elif rain > 5:
            condition = "Mưa vừa - Cân nhắc hoạt động trong nhà"
        elif rain > 2:
            condition = "Mưa nhỏ - Nên mang ô"
        elif temp_max > 32:
            condition = "Nắng nóng - Nên hoạt động ngoài trời vào sáng/chiều"
        elif temp_max < 20:
            condition = "Mát mẻ - Tốt cho mọi hoạt động"
        else:
            condition = "Thời tiết đẹp - Tốt cho hoạt động ngoài trời"

        lines.append(
            f"Ngày {i} ({day.date}): {temp_min:.0f}-{temp_max:.0f}°C, "
            f"mưa {rain:.1f}mm - {condition}"
        )

    return "\n".join(lines)
