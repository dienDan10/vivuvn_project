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


class ConfigurationError(VivuVNBaseException):
    """Raised when there's a configuration error."""
    
    def __init__(self, message: str, setting_name: Optional[str] = None):
        super().__init__(
            message=message,
            error_code="CONFIGURATION_ERROR",
            details={"setting_name": setting_name} if setting_name else {}
        )


class DatabaseError(VivuVNBaseException):
    """Raised when there's a database-related error."""
    
    def __init__(self, message: str, operation: Optional[str] = None):
        super().__init__(
            message=message,
            error_code="DATABASE_ERROR",
            details={"operation": operation} if operation else {}
        )


class DatabaseConnectionError(DatabaseError):
    """Raised when database connection fails."""
    
    def __init__(self, message: str = "Failed to connect to database"):
        super().__init__(message=message, operation="connection")


class VectorSearchError(DatabaseError):
    """Raised when vector search operations fail."""
    
    def __init__(self, message: str, query: Optional[str] = None):
        super().__init__(
            message=message,
            operation="vector_search"
        )
        if query:
            self.details["query"] = query


class AIServiceError(VivuVNBaseException):
    """Raised when AI service operations fail."""
    
    def __init__(
        self,
        message: str,
        service_name: str = "gemini",
        operation: Optional[str] = None
    ):
        super().__init__(
            message=message,
            error_code="AI_SERVICE_ERROR",
            details={
                "service_name": service_name,
                "operation": operation
            }
        )


class GeminiAPIError(AIServiceError):
    """Raised when Google Gemini API calls fail."""
    
    def __init__(self, message: str, api_error: Optional[str] = None):
        super().__init__(
            message=message,
            service_name="gemini",
            operation="api_call"
        )
        if api_error:
            self.details["api_error"] = api_error


class EmbeddingError(AIServiceError):
    """Raised when text embedding operations fail."""
    
    def __init__(self, message: str, text: Optional[str] = None):
        super().__init__(
            message=message,
            service_name="embedding",
            operation="text_embedding"
        )
        if text:
            self.details["text_sample"] = text[:100] + "..." if len(text) > 100 else text


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


class InvalidTravelRequestError(TravelPlanningError):
    """Raised when travel request validation fails."""
    
    def __init__(self, message: str, field: Optional[str] = None):
        super().__init__(
            message=message,
            operation="request_validation"
        )
        if field:
            self.details["invalid_field"] = field


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


class RateLimitError(VivuVNBaseException):
    """Raised when rate limits are exceeded."""
    
    def __init__(
        self,
        message: str = "Rate limit exceeded",
        retry_after: Optional[int] = None
    ):
        super().__init__(
            message=message,
            error_code="RATE_LIMIT_ERROR",
            details={"retry_after": retry_after} if retry_after else {}
        )


class AuthenticationError(VivuVNBaseException):
    """Raised when authentication fails."""
    
    def __init__(self, message: str = "Authentication failed"):
        super().__init__(
            message=message,
            error_code="AUTHENTICATION_ERROR"
        )


class AuthorizationError(VivuVNBaseException):
    """Raised when authorization fails."""
    
    def __init__(self, message: str = "Insufficient permissions"):
        super().__init__(
            message=message,
            error_code="AUTHORIZATION_ERROR"
        )


class ValidationError(VivuVNBaseException):
    """Raised when input validation fails."""
    
    def __init__(
        self,
        message: str,
        field: Optional[str] = None,
        value: Optional[Any] = None
    ):
        super().__init__(
            message=message,
            error_code="VALIDATION_ERROR",
            details={
                "field": field,
                "value": str(value) if value is not None else None
            }
        )


class ExternalServiceError(VivuVNBaseException):
    """Raised when external service calls fail."""
    
    def __init__(
        self,
        message: str,
        service_name: str,
        status_code: Optional[int] = None
    ):
        super().__init__(
            message=message,
            error_code="EXTERNAL_SERVICE_ERROR",
            details={
                "service_name": service_name,
                "status_code": status_code
            }
        )


class ResourceNotFoundError(VivuVNBaseException):
    """Raised when a requested resource is not found."""
    
    def __init__(
        self,
        message: str,
        resource_type: Optional[str] = None,
        resource_id: Optional[str] = None
    ):
        super().__init__(
            message=message,
            error_code="RESOURCE_NOT_FOUND",
            details={
                "resource_type": resource_type,
                "resource_id": resource_id
            }
        )


class CacheError(VivuVNBaseException):
    """Raised when cache operations fail."""
    
    def __init__(self, message: str, operation: Optional[str] = None):
        super().__init__(
            message=message,
            error_code="CACHE_ERROR",
            details={"operation": operation} if operation else {}
        )


# Exception mapping for HTTP status codes
EXCEPTION_HTTP_STATUS_MAP = {
    VivuVNBaseException: 500,
    ConfigurationError: 500,
    DatabaseError: 500,
    DatabaseConnectionError: 503,
    VectorSearchError: 500,
    AIServiceError: 502,
    GeminiAPIError: 502,
    EmbeddingError: 500,
    TravelPlanningError: 400,
    InvalidTravelRequestError: 400,
    ItineraryGenerationError: 500,
    DataLoadingError: 500,
    RateLimitError: 429,
    AuthenticationError: 401,
    AuthorizationError: 403,
    ValidationError: 422,
    ExternalServiceError: 502,
    ResourceNotFoundError: 404,
    CacheError: 500,
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
    "ConfigurationError",
    "DatabaseError",
    "DatabaseConnectionError",
    "VectorSearchError",
    "AIServiceError",
    "GeminiAPIError",
    "EmbeddingError",
    "TravelPlanningError",
    "InvalidTravelRequestError",
    "ItineraryGenerationError",
    "DataLoadingError",
    "RateLimitError",
    "AuthenticationError",
    "AuthorizationError",
    "ValidationError",
    "ExternalServiceError",
    "ResourceNotFoundError",
    "CacheError",
    "get_http_status_code",
    "format_error_response",
]