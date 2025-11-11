"""
Google Gemini API client wrapper.

Low-level client for Google Gemini API - handles embedding generation and content generation.
Provides retry logic, error handling, and structured logging.
"""

import asyncio
import structlog
from typing import Optional, List

from google import genai
from google.genai import types
from google.api_core import exceptions as google_exceptions

from app.core.config import settings

logger = structlog.get_logger(__name__)


class GeminiClient:
    """
    Wrapper around Google Gemini API client.

    Provides high-level methods for:
    - Embedding generation (embed_content)
    - Content generation (generate_content)

    Handles initialization, error handling, and logging.
    """

    def __init__(self):
        """Initialize Google Gemini API client."""
        logger.info(
            "Initializing Gemini client",
            model=settings.GEMINI_MODEL,
            embedding_model=settings.EMBEDDING_MODEL
        )
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)
        self.model = settings.GEMINI_MODEL
        self.embedding_model = settings.EMBEDDING_MODEL
        logger.info("Gemini client initialized successfully")

    async def embed_content(
        self,
        text: str,
        task_type: str = "RETRIEVAL_DOCUMENT"
    ) -> List[float]:
        """
        Generate embeddings for text using Gemini API.

        Args:
            text: Text to embed
            task_type: Task type for embedding (RETRIEVAL_DOCUMENT or RETRIEVAL_QUERY)

        Returns:
            768-dimensional embedding vector

        Raises:
            Exception: If embedding generation fails
        """
        try:
            embedding = await asyncio.get_event_loop().run_in_executor(
                None,
                lambda: self.client.models.embed_content(
                    model=self.embedding_model,
                    contents=text,
                    config=types.EmbedContentConfig(
                        output_dimensionality=settings.VECTOR_DIMENSION,
                        task_type=task_type
                    )
                )
            )
            return embedding.embeddings[0].values

        except Exception as e:
            logger.error(
                "Gemini embedding generation failed",
                error=str(e),
                error_code="GEMINI_EMBEDDING_ERROR",
                task_type=task_type,
                text_length=len(text),
                exc_info=True
            )
            raise

    async def generate_content(
        self,
        config: types.GenerateContentConfig,
        contents: str,
        attempt: int = 0,
        max_retries: int = 3
    ):
        """
        Generate content using Gemini API with retry logic.

        Args:
            config: GenerateContentConfig with system instruction and response schema
            contents: User prompt/input
            attempt: Current retry attempt (0-based)
            max_retries: Maximum number of retries for transient failures

        Returns:
            Gemini API response object

        Raises:
            Exception: If generation fails after retries
        """
        try:
            response = await asyncio.get_event_loop().run_in_executor(
                None,
                lambda: self.client.models.generate_content(
                    model=self.model,
                    config=config,
                    contents=contents
                )
            )
            return response

        except google_exceptions.ServiceUnavailable as e:
            # 503: Service temporarily unavailable - retry
            if attempt < max_retries:
                delay = min(1.0 * (2 ** attempt), 10.0)  # Exponential backoff
                logger.warning(
                    "Gemini 503 error, retrying",
                    attempt=attempt + 1,
                    max_retries=max_retries,
                    delay=delay,
                    error=str(e)
                )
                await asyncio.sleep(delay)
                return await self.generate_content(config, contents, attempt + 1, max_retries)
            else:
                logger.error(
                    "Gemini 503 error - Max retries exhausted",
                    max_retries=max_retries,
                    error=str(e),
                    error_code="GEMINI_503_MAX_RETRIES"
                )
                raise

        except asyncio.TimeoutError as e:
            # Timeout: Retry once
            if attempt < 1:
                logger.warning(
                    "Gemini request timeout, retrying",
                    attempt=attempt + 1,
                    error=str(e)
                )
                await asyncio.sleep(2.0)
                return await self.generate_content(config, contents, attempt + 1, max_retries)
            else:
                logger.error(
                    "Gemini timeout - Max retries exhausted",
                    error=str(e),
                    error_code="GEMINI_TIMEOUT_MAX_RETRIES"
                )
                raise

        except google_exceptions.Unauthenticated as e:
            # 401: Authentication failed - don't retry
            logger.error(
                "Gemini authentication failed",
                error=str(e),
                error_code="GEMINI_AUTH_ERROR"
            )
            raise

        except Exception as e:
            # Check if error message contains safety filter indication
            error_str = str(e).lower()
            if "safety" in error_str or "blocked" in error_str or "policy" in error_str:
                logger.error(
                    "Gemini safety filter triggered",
                    error=str(e),
                    error_code="GEMINI_SAFETY_FILTER"
                )
                raise

            # Unknown error
            logger.error(
                "Gemini API error",
                error=str(e),
                error_code="GEMINI_API_ERROR",
                exc_info=True
            )
            raise


# ============================================================================
# SINGLETON PATTERN
# ============================================================================

_gemini_client: Optional[GeminiClient] = None


def get_gemini_client() -> GeminiClient:
    """
    Get singleton Gemini client instance.

    Creates the client on first call, then returns the same instance
    for all subsequent calls. This ensures only one Gemini client
    (and one HTTP connection pool) is used across the application.

    Returns:
        GeminiClient singleton instance
    """
    global _gemini_client
    if _gemini_client is None:
        _gemini_client = GeminiClient()
    return _gemini_client


__all__ = ["GeminiClient", "get_gemini_client"]
