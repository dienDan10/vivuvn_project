"""
Middleware configuration for FastAPI application.

This module provides centralized middleware setup for logging, CORS, and security.
"""

import time
import structlog
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware

from app.core.config import settings, get_cors_settings

logger = structlog.get_logger(__name__)


async def log_requests(request: Request, call_next):
    """Log all HTTP requests with timing information."""
    start_time = time.time()

    # Log request
    logger.info(
        "HTTP request started",
        method=request.method,
        url=str(request.url),
        client_ip=request.client.host if request.client else None,
        user_agent=request.headers.get("user-agent")
    )

    # Process request
    response = await call_next(request)

    # Calculate processing time
    process_time = time.time() - start_time

    # Log response
    logger.info(
        "HTTP request completed",
        method=request.method,
        url=str(request.url),
        status_code=response.status_code,
        process_time=round(process_time, 4)
    )

    # Add processing time header
    response.headers["X-Process-Time"] = str(process_time)

    return response


def register_middleware(app: FastAPI):
    """
    Register all middleware with the FastAPI application.

    Middleware stack (processed in reverse order):
    1. CORS middleware - Handle cross-origin requests
    2. TrustedHost middleware (production only) - Restrict to allowed hosts
    3. Request logging middleware - Log all HTTP requests

    Args:
        app: FastAPI application instance
    """
    # Add CORS middleware
    app.add_middleware(
        CORSMiddleware,
        **get_cors_settings()
    )

    # Add trusted host middleware for security (production only)
    if not settings.DEBUG:
        app.add_middleware(
            TrustedHostMiddleware,
            allowed_hosts=["*"]  # Configure with specific hosts in production
        )

    # Add request logging middleware
    app.middleware("http")(log_requests)


__all__ = ["register_middleware"]
