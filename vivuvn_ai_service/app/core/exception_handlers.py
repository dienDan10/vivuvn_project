"""
Custom exception handlers for FastAPI application.

This module provides centralized exception handling for the ViVu Vietnam AI Service.
All exceptions are logged with structured logging and formatted as JSON responses.
"""

import structlog
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError

from app.core.exceptions import (
    VivuVNBaseException,
    get_http_status_code,
    format_error_response
)
from app.core.config import settings

logger = structlog.get_logger(__name__)


async def vivuvn_exception_handler(request: Request, exc: VivuVNBaseException):
    """Handle custom application exceptions.

    Note: VivuVNBaseException and subclasses are already logged in the client/service/agent
    layers with rich context (error details, parameters, etc.). This handler only formats
    the error response without re-logging to avoid duplicate log entries.
    """
    status_code = get_http_status_code(exc)
    return JSONResponse(
        status_code=status_code,
        content=format_error_response(exc)
    )


async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """Handle request validation errors.

    Note: Request validation errors are framework-level errors. Logging is minimal
    since FastAPI's middleware already logs request details.
    """
    return JSONResponse(
        status_code=422,
        content={
            "error": {
                "message": "Request validation failed",
                "code": "VALIDATION_ERROR",
                "details": {"validation_errors": exc.errors()}
            }
        }
    )


async def http_exception_handler(request: Request, exc: HTTPException):
    """Handle HTTP exceptions.

    Note: HTTP exceptions (404, 403, etc.) are framework-level errors typically raised
    by FastAPI for missing routes or auth failures. They don't need additional logging.
    """
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "message": exc.detail,
                "code": "HTTP_ERROR",
                "details": {"status_code": exc.status_code}
            }
        }
    )


async def general_exception_handler(request: Request, exc: Exception):
    """Handle unexpected exceptions that bypass all other handlers.

    These are unexpected exceptions that weren't caught by client/service/agent layers.
    They are logged here because they bypass all other logging points.
    """
    logger.error(
        "Unexpected exception occurred",
        error=str(exc),
        error_type=type(exc).__name__,
        path=request.url.path,
        method=request.method,
        client_ip=request.client.host if request.client else None,
        exc_info=True
    )

    return JSONResponse(
        status_code=500,
        content={
            "error": {
                "message": "Internal server error",
                "code": "INTERNAL_ERROR",
                "details": {"error_type": type(exc).__name__} if settings.DEBUG else {}
            }
        }
    )


def register_exception_handlers(app: FastAPI):
    """
    Register all custom exception handlers with the FastAPI application.

    Args:
        app: FastAPI application instance
    """
    app.add_exception_handler(VivuVNBaseException, vivuvn_exception_handler)
    app.add_exception_handler(RequestValidationError, validation_exception_handler)
    app.add_exception_handler(HTTPException, http_exception_handler)
    app.add_exception_handler(Exception, general_exception_handler)


__all__ = ["register_exception_handlers"]
