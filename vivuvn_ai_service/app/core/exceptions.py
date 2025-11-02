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
        status_code: int = 500,
        error_type: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None
    ):
        self.message = message
        self.status_code = status_code
        self.error_type = error_type or self.__class__.__name__
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
            status_code=400,
            error_type="TravelPlanningError",
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


class ExternalServiceError(VivuVNBaseException):
    """Raised when external service (Gemini, Pinecone, etc) is unavailable."""

    def __init__(self, message: str, service: Optional[str] = None):
        super().__init__(
            message=message,
            status_code=502,
            error_type="ExternalServiceError",
            details={"service": service}
        )


class ServiceUnavailableError(ExternalServiceError):
    """Raised when service returns 503."""

    def __init__(self, message: str, service: Optional[str] = None):
        super().__init__(message, service)
        self.status_code = 503
        self.error_type = "ServiceUnavailableError"


class ContentPolicyError(ItineraryGenerationError):
    """Raised when content violates safety policies."""

    def __init__(self, message: str):
        super().__init__(message)
        self.status_code = 400
        self.error_type = "ContentPolicyError"


class NoResultsError(TravelPlanningError):
    """Raised when no places found for given destination."""

    def __init__(self, message: str, destination: Optional[str] = None):
        super().__init__(message, destination, "search")
        self.status_code = 404
        self.error_type = "NoResultsError"


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
            status_code=500,
            error_type="DataLoadingError",
            details={
                "file_path": file_path,
                "operation": operation
            }
        )


class WeatherServiceError(VivuVNBaseException):
    """Base exception for weather service errors."""

    def __init__(self, message: str, status_code: int = 500):
        super().__init__(message, status_code, error_type="WeatherServiceError")


class WeatherAPIError(WeatherServiceError):
    """Weather API communication error."""

    def __init__(self, message: str):
        super().__init__(message, status_code=502)


class AuthenticationError(WeatherServiceError):
    """Invalid API key."""

    def __init__(self, message: str):
        super().__init__(message, status_code=401)


class RateLimitError(WeatherServiceError):
    """Rate limit exceeded."""

    def __init__(self, message: str):
        super().__init__(message, status_code=429)


# Error message constants
ERROR_MESSAGES = {
    "SERVICE_UNAVAILABLE": "Service temporarily unavailable. Please try again.",
    "EXTERNAL_SERVICE_DOWN": "External service is temporarily unavailable. Please try again.",
    "GEMINI_AUTH_ERROR": "Internal service configuration error",
    "GEMINI_TIMEOUT": "Request timeout. Please try again.",
    "CONTENT_POLICY_VIOLATION": "Your request violates content policy. Please rephrase.",
    "NO_PLACES_FOUND": "No places found for the specified destination. Please try a different destination.",
    "VALIDATION_FAILED": "Itinerary validation failed. Please try again.",
}


def get_http_status_code(exception: Exception) -> int:
    """
    Get appropriate HTTP status code for an exception.
    
    Args:
        exception: Exception instance
        
    Returns:
        int: HTTP status code
    """
    if isinstance(exception, VivuVNBaseException):
        return exception.status_code
    return 500


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
            "status_code": exception.status_code,
            "type": exception.error_type,
            "details": exception.details
        }
    }


# Export all exceptions and utilities
__all__ = [
    "VivuVNBaseException",
    "TravelPlanningError",
    "ItineraryGenerationError",
    "ExternalServiceError",
    "ServiceUnavailableError",
    "ContentPolicyError",
    "NoResultsError",
    "DataLoadingError",
    "WeatherServiceError",
    "WeatherAPIError",
    "AuthenticationError",
    "RateLimitError",
    "ERROR_MESSAGES",
    "get_http_status_code",
    "format_error_response",
]