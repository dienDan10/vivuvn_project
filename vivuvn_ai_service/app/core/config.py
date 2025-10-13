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
    EMBEDDING_MODEL: str = "huyydangg/DEk21_hcmute_embedding"  # Vietnamese-specific embedding model
    VECTOR_DIMENSION: int = 768  # Standard dimension for most transformer models

    # Pinecone Configuration (Serverless)
    PINECONE_API_KEY: Optional[str] = None
    PINECONE_INDEX_NAME: str = "vivuvn-travel"
    PINECONE_CLOUD: str = "aws"  # AWS, GCP, or Azure
    PINECONE_REGION: str = "us-east-1"  # Region for serverless

    # Pinecone Query Optimization
    PINECONE_INCLUDE_VALUES: bool = False  # Don't return vectors in query results
    PINECONE_SHOW_PROGRESS: bool = False   # Disable progress tracking in production
    PINECONE_METRIC: str = "cosine"        # Explicit similarity metric
    PINECONE_DEFAULT_NAMESPACE: str = ""   # Default namespace (empty string)

    # Dynamic top_k Configuration (optimizes search based on trip duration)
    VECTOR_SEARCH_BASE_K: int = 8         # Baseline places for any search
    VECTOR_SEARCH_MIN_K: int = 8           # Minimum top_k (short trips)
    VECTOR_SEARCH_MAX_K: int = 50           # Maximum top_k (prevent excessive fetches)
    VECTOR_SEARCH_ACTIVITIES_PER_DAY: float = 3.5  # Expected activities per day
    VECTOR_SEARCH_DIVERSITY_FACTOR: float = 2.0    # Fetch 2x for AI selection diversity

    # AI Configuration (Updated to use google-genai v0.12+)
    GEMINI_API_KEY: Optional[str] = None
    GEMINI_MODEL: str = "gemini-2.5-flash"

    # Server Configuration
    HOST: str = "localhost"
    PORT: int = 8000

    # AI Model Parameters
    MAX_TOKENS: int = 16384  # Increased for complex travel itineraries
    TEMPERATURE: float = 0.5
    
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
