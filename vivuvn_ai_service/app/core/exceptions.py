"""
Custom exceptions for ViVu Vietnam AI Service.

This module defines application-specific exceptions for better error handling
and user experience.
"""

from typing import Any, Dict, Optional


class VivuVNBaseException(Exception):
    """Base exception class for ViVu Vietnam AI Service."""
    
    def __init__(
        self,
        message: str,
        error_code: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None
    ):
        self.message = message
        self.error_code = error_code
        self.details = details or {}
        super().__init__(self.message)


class TravelPlanningError(VivuVNBaseException):
    """Raised when travel planning operations fail."""
    
    def __init__(
        self,
        message: str,
        destination: Optional[str] = None,
        operation: Optional[str] = None
    ):
        super().__init__(
            message=message,
            error_code="TRAVEL_PLANNING_ERROR",
            details={
                "destination": destination,
                "operation": operation
            }
        )


class ItineraryGenerationError(TravelPlanningError):
    """Raised when itinerary generation fails."""
    
    def __init__(self, message: str, destination: Optional[str] = None):
        super().__init__(
            message=message,
            destination=destination,
            operation="itinerary_generation"
        )


class DataLoadingError(VivuVNBaseException):
    """Raised when data loading operations fail."""

    def __init__(
        self,
        message: str,
        file_path: Optional[str] = None,
        operation: Optional[str] = None
    ):
        super().__init__(
            message=message,
            error_code="DATA_LOADING_ERROR",
            details={
                "file_path": file_path,
                "operation": operation
            }
        )


class WeatherServiceError(VivuVNBaseException):
    """Base exception for weather service errors."""

    def __init__(self, message: str, error_code: str = "WEATHER_ERROR"):
        super().__init__(message, error_code)
        self.http_status_code = 500


class WeatherAPIError(WeatherServiceError):
    """Weather API communication error."""

    def __init__(self, message: str):
        super().__init__(message, "WEATHER_API_ERROR")


class AuthenticationError(WeatherServiceError):
    """Invalid API key."""

    def __init__(self, message: str):
        super().__init__(message, "WEATHER_AUTH_ERROR")
        self.http_status_code = 401


class RateLimitError(WeatherServiceError):
    """Rate limit exceeded."""

    def __init__(self, message: str):
        super().__init__(message, "WEATHER_RATE_LIMIT")
        self.http_status_code = 429


# Exception mapping for HTTP status codes
EXCEPTION_HTTP_STATUS_MAP = {
    VivuVNBaseException: 500,
    TravelPlanningError: 400,
    ItineraryGenerationError: 500,
    DataLoadingError: 500,
    WeatherServiceError: 500,
    WeatherAPIError: 500,
    AuthenticationError: 401,
    RateLimitError: 429,
}


def get_http_status_code(exception: Exception) -> int:
    """
    Get appropriate HTTP status code for an exception.
    
    Args:
        exception: Exception instance
        
    Returns:
        int: HTTP status code
    """
    exception_type = type(exception)
    return EXCEPTION_HTTP_STATUS_MAP.get(exception_type, 500)


def format_error_response(exception: VivuVNBaseException) -> Dict[str, Any]:
    """
    Format exception as error response dictionary.
    
    Args:
        exception: VivuVN exception instance
        
    Returns:
        dict: Formatted error response
    """
    return {
        "error": {
            "message": exception.message,
            "code": exception.error_code,
            "details": exception.details
        }
    }


# Export all exceptions and utilities
__all__ = [
    "VivuVNBaseException",
    "TravelPlanningError",
    "ItineraryGenerationError",
    "DataLoadingError",
    "WeatherServiceError",
    "WeatherAPIError",
    "AuthenticationError",
    "RateLimitError",
    "get_http_status_code",
    "format_error_response",
]