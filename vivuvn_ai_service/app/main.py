"""
FastAPI main application for ViVu Vietnam AI Service.

This module sets up the FastAPI application with middleware, exception handlers,
and route registration.
"""

import logging
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
import structlog

from app.core.config import settings, get_cors_settings
from app.core.exceptions import (
    VivuVNBaseException, 
    get_http_status_code, 
    format_error_response
)
from app.api.routes.travel_planner import router as travel_router
from app.api.routes.data_management import router as data_router
from app.api.schemas import HealthCheckResponse, ErrorResponse

# Configure structured logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        structlog.processors.JSONRenderer()
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan manager for startup and shutdown events.
    
    Args:
        app: FastAPI application instance
    """
    # Startup
    logger.info("Starting ViVu Vietnam AI Service")
    
    try:
        # Initialize AI services
        logger.info("AI service initialization completed")
        
        # Additional startup tasks can be added here
        # - Load models
        # - Setup caching
        # - Verify Pinecone connection
        
        logger.info("Application startup completed successfully")
        
    except Exception as e:
        logger.error("Application startup failed", error=str(e))
        raise
    
    yield
    
    # Shutdown
    logger.info("Shutting down ViVu Vietnam AI Service")
    
    try:
        logger.info("AI service cleanup completed")
        
        # Additional cleanup tasks
        logger.info("Application shutdown completed successfully")
        
    except Exception as e:
        logger.error("Application shutdown failed", error=str(e))

 
# Create FastAPI application
app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="AI-powered travel itinerary generator for Vietnam destinations",
    docs_url="/docs" if settings.DEBUG else None,
    redoc_url="/redoc" if settings.DEBUG else None,
    openapi_url="/openapi.json" if settings.DEBUG else None,
    lifespan=lifespan
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    **get_cors_settings()
)

# Add trusted host middleware for security
if not settings.DEBUG:
    app.add_middleware(
        TrustedHostMiddleware,
        allowed_hosts=["*"]  # Configure with specific hosts in production
    )


# Request logging middleware
@app.middleware("http")
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


# Exception handlers
@app.exception_handler(VivuVNBaseException)
async def vivuvn_exception_handler(request: Request, exc: VivuVNBaseException):
    """Handle custom application exceptions."""
    logger.error(
        "Application exception occurred",
        error_code=exc.error_code,
        message=exc.message,
        details=exc.details,
        path=request.url.path
    )
    
    status_code = get_http_status_code(exc)
    return JSONResponse(
        status_code=status_code,
        content=format_error_response(exc)
    )


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """Handle request validation errors."""
    logger.warning(
        "Request validation failed",
        errors=exc.errors(),
        path=request.url.path
    )
    
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


@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    """Handle HTTP exceptions."""
    logger.warning(
        "HTTP exception",
        status_code=exc.status_code,
        detail=exc.detail,
        path=request.url.path
    )
    
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


@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    """Handle unexpected exceptions."""
    logger.error(
        "Unexpected exception occurred",
        error=str(exc),
        error_type=type(exc).__name__,
        path=request.url.path,
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


# Health check endpoint
@app.get("/health", response_model=HealthCheckResponse)
async def health_check():
    """
    Health check endpoint to verify service status.
    
    Returns:
        HealthCheckResponse: Service health information
    """
    try:
        # Check AI services health
        services_status = {
            "pinecone": "configured" if settings.PINECONE_API_KEY else "not_configured",
            "gemini_ai": "configured" if settings.GEMINI_API_KEY else "not_configured",
            "embedding_service": "ready"
        }
        
        # Determine overall status
        overall_status = "healthy" if all(
            status in ["configured", "ready"] for status in services_status.values()
        ) else "degraded"
        
        return HealthCheckResponse(
            status=overall_status,
            version=settings.VERSION,
            services=services_status
        )
        
    except Exception as e:
        logger.error("Health check failed", error=str(e))
        return HealthCheckResponse(
            status="unhealthy",
            version=settings.VERSION,
            services={"error": str(e)}
        )


# Root endpoint
@app.get("/")
async def root():
    """Root endpoint with service information."""
    return {
        "service": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "description": "AI-powered travel itinerary generator for Vietnam destinations",
        "docs_url": "/docs" if settings.DEBUG else None,
        "health_url": "/health",
        "api_v1": settings.API_V1_STR
    }


# Register API routes
app.include_router(
    travel_router,
    prefix=settings.API_V1_STR,
    tags=["Travel Planning"]
)

app.include_router(
    data_router,
    prefix=f"{settings.API_V1_STR}/data",
    tags=["Data Management"]
)


# Additional endpoints for development
if settings.DEBUG:
    
    @app.get("/debug/config")
    async def debug_config():
        """Debug endpoint to view configuration (development only)."""
        return {
            "project_name": settings.PROJECT_NAME,
            "version": settings.VERSION,
            "debug": settings.DEBUG,
            "log_level": settings.LOG_LEVEL,
            "pinecone_configured": bool(settings.PINECONE_API_KEY),
            "ai_configured": bool(settings.GEMINI_API_KEY),
            "vector_dimension": settings.VECTOR_DIMENSION,
        }
    
    @app.get("/debug/services")
    async def debug_services():
        """Debug endpoint for service information (development only)."""
        try:
            return {
                "pinecone": {
                    "configured": bool(settings.PINECONE_API_KEY),
                    "index_name": settings.PINECONE_INDEX_NAME,
                    "cloud": settings.PINECONE_CLOUD,
                    "region": settings.PINECONE_REGION,
                    "mode": "serverless"
                },
                "gemini": {
                    "configured": bool(settings.GEMINI_API_KEY)
                },
                "embedding_model": settings.EMBEDDING_MODEL,
                "vector_dimension": settings.VECTOR_DIMENSION,
                "service_type": "standalone_ai_service"
            }
        except Exception as e:
            return {"error": str(e)}


# Application metadata
app.title = settings.PROJECT_NAME
app.version = settings.VERSION
app.description = """
# ViVu Vietnam AI Service 🇻🇳

An AI-powered travel itinerary generator specifically designed for Vietnam destinations.
This is a standalone AI service that integrates with external systems via API.

## Features

- **Intelligent Itinerary Generation**: Uses Google Gemini AI with RAG pattern
- **Vietnam-Focused**: Specialized knowledge base for Vietnamese destinations
- **Vector Search**: Semantic search using Pinecone vector database
- **Cultural Insights**: Authentic Vietnamese travel experiences
- **Cost Estimation**: Realistic pricing in Vietnamese Dong (VND)

## Usage

1. **Generate Itinerary**: POST to `/api/v1/travel/generate-itinerary`
2. **Health Check**: GET `/health`

Built with FastAPI, LangChain, Google Gemini, and Pinecone vector database.
"""

# Configure OpenAPI
app.openapi_tags = [
    {
        "name": "Travel Planning",
        "description": "AI-powered travel itinerary generation for Vietnam destinations",
    },
    {
        "name": "Data Management",
        "description": "Endpoints for managing travel data in Pinecone vector database",
    },
    {
        "name": "Health",
        "description": "Service health and monitoring endpoints",
    },
]

if __name__ == "__main__":
    import uvicorn
    
    # Run the application
    uvicorn.run(
        "app.main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG,
        log_level=settings.LOG_LEVEL.lower(),
        access_log=True
    )