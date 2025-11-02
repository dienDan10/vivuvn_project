"""
FastAPI main application for ViVu Vietnam AI Service.

This module sets up the FastAPI application with middleware, exception handlers,
and route registration.
"""

import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
import structlog

from app.core.config import settings
from app.core.exception_handlers import register_exception_handlers
from app.core.middleware import register_middleware
from app.api.routes.travel_planner import router as travel_router
from app.api.routes.data_management import router as data_router
from app.api.schemas import HealthCheckResponse

# Configure structured logging
structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.stdlib.filter_by_level,  # Filter by log level
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.UnicodeDecoder(),
        structlog.stdlib.ProcessorFormatter.wrap_for_formatter,
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

# Setup handler with ConsoleRenderer
handler = logging.StreamHandler()
handler.setFormatter(structlog.stdlib.ProcessorFormatter(
    processor=structlog.dev.ConsoleRenderer(),
))
root_logger = logging.getLogger()
# Clear any existing handlers to prevent duplication
root_logger.handlers.clear()
root_logger.addHandler(handler)
root_logger.setLevel(getattr(logging, settings.LOG_LEVEL.upper()))

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

# Register middleware and exception handlers
register_middleware(app)
register_exception_handlers(app)


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
    # Note: log_config=None disables uvicorn's default logging config to prevent duplication
    uvicorn.run(
        "app.main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG,
        log_level=settings.LOG_LEVEL.lower(),
        access_log=False
    )