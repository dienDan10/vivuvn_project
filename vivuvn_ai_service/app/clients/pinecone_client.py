"""
Pinecone API client wrapper.

Low-level client for Pinecone vector database - handles index management and access.
Provides index creation, list, describe, and reference retrieval operations.
Uses gRPC protocol (v6+) for better performance.
"""

from typing import Optional, List, Dict, Any

import structlog

from app.core.config import settings

logger = structlog.get_logger(__name__)

try:
    from pinecone import Pinecone, ServerlessSpec
    from pinecone.grpc import PineconeGRPC
except Exception:
    Pinecone = None
    ServerlessSpec = None
    PineconeGRPC = None


class PineconeClientError(Exception):
    """Pinecone client-specific exception."""
    pass


class PineconeClient:
    """
    Wrapper around Pinecone vector database client.

    Provides high-level methods for:
    - Index management (create, list, describe)
    - Index access (get_index)
    - Connection pooling configuration

    Uses PineconeGRPC (v6+) for better performance with fallback to standard client.
    """

    def __init__(self, api_key: str):
        """
        Initialize Pinecone client.

        Args:
            api_key: Pinecone API key

        Raises:
            PineconeClientError: If Pinecone SDK is not installed or initialization fails
        """
        if Pinecone is None:
            raise PineconeClientError("Pinecone SDK is not installed")

        if not api_key:
            raise PineconeClientError("Pinecone API key is required")

        logger.info("Initializing Pinecone client")

        self.api_key = api_key

        # Initialize Pinecone with v6+ API (using gRPC for better performance)
        try:
            self.pc = PineconeGRPC(api_key=self.api_key) if PineconeGRPC else Pinecone(api_key=self.api_key)
            logger.info("Pinecone client initialized with gRPC protocol")
        except Exception as e:
            # Fallback to standard Pinecone client
            logger.warning("Failed to initialize PineconeGRPC, falling back to standard client", error=str(e))
            self.pc = Pinecone(api_key=self.api_key)
            logger.info("Pinecone client initialized with standard protocol")

    def get_index(self, index_name: str, pool_threads: int = 50):
        """
        Get a reference to a Pinecone index with connection pooling configuration.

        Args:
            index_name: Name of the index
            pool_threads: Number of threads for connection pooling (default: 50)

        Returns:
            Pinecone Index object

        Raises:
            PineconeClientError: If index access fails
        """
        try:
            index = self.pc.Index(index_name, pool_threads=pool_threads)
            logger.info("Index reference retrieved", index_name=index_name, pool_threads=pool_threads)
            return index
        except Exception as e:
            logger.error("Failed to get index reference", index_name=index_name, error=str(e))
            raise PineconeClientError(f"Failed to get index reference for '{index_name}': {e}")

    def create_index(
        self,
        name: str,
        dimension: int,
        metric: str = "cosine",
        cloud: str = "aws",
        region: str = "us-east-1"
    ) -> bool:
        """
        Create a serverless Pinecone index.

        Args:
            name: Index name
            dimension: Vector dimension
            metric: Distance metric (cosine, euclidean, dotproduct)
            cloud: Cloud provider (aws, gcp, azure)
            region: Cloud region

        Returns:
            True if index was created, False if already exists

        Raises:
            PineconeClientError: If creation fails
        """
        try:
            # Check if index already exists
            existing_indexes = [index.name for index in self.pc.list_indexes()]

            if name in existing_indexes:
                logger.info("Index already exists", index_name=name)
                return False

            logger.info("Creating serverless index", index_name=name, dimension=dimension, metric=metric)

            self.pc.create_index(
                name=name,
                dimension=dimension,
                metric=metric,
                spec=ServerlessSpec(cloud=cloud, region=region)
            )

            logger.info("Serverless index created successfully", index_name=name)
            return True

        except Exception as e:
            logger.error("Failed to create index", index_name=name, error=str(e))
            raise PineconeClientError(f"Failed to create index '{name}': {e}")

    def list_indexes(self) -> List[str]:
        """
        List all indexes in the Pinecone project.

        Returns:
            List of index names

        Raises:
            PineconeClientError: If operation fails
        """
        try:
            indexes = [index.name for index in self.pc.list_indexes()]
            logger.info("Listed indexes", count=len(indexes))
            return indexes
        except Exception as e:
            logger.error("Failed to list indexes", error=str(e))
            raise PineconeClientError(f"Failed to list indexes: {e}")

    def describe_index(self, index_name: str) -> Dict[str, Any]:
        """
        Get detailed information about a Pinecone index.

        Args:
            index_name: Name of the index

        Returns:
            Index metadata dictionary

        Raises:
            PineconeClientError: If operation fails
        """
        try:
            description = self.pc.describe_index(index_name)
            logger.info("Index description retrieved", index_name=index_name)
            return description
        except Exception as e:
            logger.error("Failed to describe index", index_name=index_name, error=str(e))
            raise PineconeClientError(f"Failed to describe index '{index_name}': {e}")

    def delete_index(self, index_name: str) -> bool:
        """
        Delete a Pinecone index.

        Args:
            index_name: Name of the index

        Returns:
            True if deleted successfully

        Raises:
            PineconeClientError: If operation fails
        """
        try:
            self.pc.delete_index(index_name)
            logger.info("Index deleted successfully", index_name=index_name)
            return True
        except Exception as e:
            logger.error("Failed to delete index", index_name=index_name, error=str(e))
            raise PineconeClientError(f"Failed to delete index '{index_name}': {e}")


# ============================================================================
# SINGLETON PATTERN
# ============================================================================

_pinecone_client: Optional[PineconeClient] = None


def get_pinecone_client() -> PineconeClient:
    """
    Get singleton Pinecone client instance.

    Creates the client on first call, then returns the same instance
    for all subsequent calls. This ensures only one Pinecone client
    (and one connection pool) is used across the application.

    Returns:
        PineconeClient singleton instance

    Raises:
        PineconeClientError: If initialization fails
    """
    global _pinecone_client
    if _pinecone_client is None:
        if not settings.PINECONE_API_KEY:
            raise PineconeClientError("Pinecone API key missing in environment variables")
        _pinecone_client = PineconeClient(api_key=settings.PINECONE_API_KEY)
    return _pinecone_client


__all__ = ["PineconeClient", "get_pinecone_client", "PineconeClientError"]
