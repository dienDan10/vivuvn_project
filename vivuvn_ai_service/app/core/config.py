"""
Configuration settings for ViVu Vietnam AI Service.
"""

from __future__ import annotations
from typing import List, Optional
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # App Configuration
    PROJECT_NAME: str = "ViVu Vietnam AI Service"
    API_V1_STR: str = "/api/v1"
    LOG_LEVEL: str = "INFO"
    DEBUG: bool = True
    VERSION: str = "0.1.0"

    # Database Configuration - Not needed for this AI service
    # DATABASE_URL: Optional[str] = None  # Commented out - using external MySQL
    
    # Embeddings Configuration
    EMBEDDING_MODEL: str = "gemini-embedding-001"  # Google Gemini embedding model
    VECTOR_DIMENSION: int = 768  # Optimized dimension (supports 128-3072, recommended: 768, 1536, 3072)

    # Gemini Embedding Task Types (for optimization)
    EMBEDDING_TASK_TYPE_DOCUMENT: str = "RETRIEVAL_DOCUMENT"  # For storing documents in vector DB
    EMBEDDING_TASK_TYPE_QUERY: str = "RETRIEVAL_QUERY"       # For user search queries

    # Pinecone Configuration (Serverless)
    PINECONE_API_KEY: Optional[str] = None
    PINECONE_INDEX_NAME: str = "vivuvn-travel"
    PINECONE_CLOUD: str = "aws"  # AWS, GCP, or Azure
    PINECONE_REGION: str = "us-east-1"  # Region for serverless

    # Pinecone Query Optimization
    PINECONE_INCLUDE_VALUES: bool = False  # Don't return vectors in query results
    PINECONE_SHOW_PROGRESS: bool = False   # Disable progress tracking in production
    PINECONE_METRIC: str = "cosine"        # Explicit similarity metric
    PINECONE_DEFAULT_NAMESPACE: str = "travel_location"   # Namespace for travel/location data

    # Dynamic top_k Configuration (optimized for token efficiency)
    VECTOR_SEARCH_BASE_K: int = 8          # Baseline places for any search
    VECTOR_SEARCH_MIN_K: int = 8           # Minimum top_k (short trips)
    VECTOR_SEARCH_MAX_K: int = 35          # Maximum top_k (token-optimized, reduced from 50)
    VECTOR_SEARCH_ACTIVITIES_PER_DAY: float = 3.0  # Activities per day (reduced from 3.5)
    VECTOR_SEARCH_DIVERSITY_FACTOR: float = 1.5    # Diversity factor (reduced from 2.0 for efficiency)

    # AI Configuration (Updated to use google-genai v0.12+)
    GEMINI_API_KEY: Optional[str] = None
    GEMINI_MODEL: str = "gemini-2.5-flash"

    # OpenWeather API Configuration
    OPENWEATHER_API_KEY: Optional[str] = None
    OPENWEATHER_BASE_URL: str = "https://api.openweathermap.org/data/3.0"
    OPENWEATHER_TIMEOUT: float = 30.0
    OPENWEATHER_MAX_CONCURRENT: int = 10

    # Server Configuration
    HOST: str = "localhost"
    PORT: int = 8000

    # AI Model Parameters
    MAX_TOKENS: int = 20000  # Optimized for faster generation while maintaining quality
    TEMPERATURE: float = 0.15  # Lower for more deterministic, faster responses

    # Prompt optimization settings
    TOP_PLACES_WITH_DESCRIPTION: int = 3
    DESCRIPTION_MAX_LENGTH: int = 60
    COORD_DECIMAL_PLACES: int = 2
    MIN_ACTIVITIES_PER_DAY: int = 3
    BUDGET_TIER_ECONOMY: int = 500_000
    BUDGET_TIER_MID_RANGE: int = 1_500_000
    BUDGET_TIER_COMFORT: int = 3_000_000
    
    # CORS Configuration
    ALLOWED_ORIGINS: List[str] = ["http://localhost:3000", "http://localhost:8080"]
    ALLOWED_METHODS: List[str] = ["GET", "POST", "PUT", "DELETE"]
    ALLOWED_HEADERS: List[str] = ["*"]

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


settings = Settings()


def get_cors_settings():
    """Get CORS settings for FastAPI middleware."""
    return {
        "allow_origins": settings.ALLOWED_ORIGINS,
        "allow_credentials": True,
        "allow_methods": settings.ALLOWED_METHODS,
        "allow_headers": settings.ALLOWED_HEADERS,
    }


__all__ = ["settings", "Settings", "get_cors_settings"]
