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
    DEBUG: bool = False
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

    # AI Configuration (Updated to use google-genai v0.12+)
    GEMINI_API_KEY: Optional[str] = None
    GOOGLE_GENAI_API_KEY: Optional[str] = None  # Alternative name for compatibility
    
    # Server Configuration
    HOST: str = "0.0.0.0"
    PORT: int = 8000

    # AI Model Parameters
    # MAX_TOKENS: int = 2048
    # TEMPERATURE: float = 0.5
    
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
