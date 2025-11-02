"""
Vector service for core Pinecone operations.

This service provides low-level Pinecone vector database operations including:
- Index management and health checks
- Vector CRUD operations (upsert, delete, search)
- Basic embedding generation for compatibility

For optimized embedding generation with Vietnamese chunking and minimal metadata,
use EmbeddingService instead. The EmbeddingService is the recommended approach
for new implementations.

Architecture:
- VectorService: Low-level Pinecone operations
- EmbeddingService: High-level embedding with chunking and optimization
"""

from typing import List, Dict, Any, Optional
import asyncio
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

class VectorServiceError(Exception):
    pass


class VectorService:
    """
    Simplified vector service focused on core Pinecone operations.
    
    This service handles low-level Pinecone operations like index management,
    vector search, and CRUD operations. For embedding generation with chunking
    and minimal metadata, use EmbeddingService instead.
    """
    
    def __init__(self, api_key: str, cloud: str = "aws", region: str = "us-east-1", index_name: str = "default"):
        if Pinecone is None:
            raise VectorServiceError("pinecone SDK is not installed")

        self.api_key = api_key
        self.cloud = cloud
        self.region = region
        self.index_name = index_name

        # Initialize Pinecone with v6+ API (using gRPC for better performance)
        try:
            self.pc = PineconeGRPC(api_key=self.api_key) if PineconeGRPC else Pinecone(api_key=self.api_key)
        except Exception:
            # Fallback to standard Pinecone client
            self.pc = Pinecone(api_key=self.api_key)

        # Create serverless index if it doesn't exist
        self._ensure_index_exists()

        # Get index reference
        self.index = self.pc.Index(self.index_name, pool_threads=50)

    def _ensure_index_exists(self):
        """Create serverless index if it doesn't exist."""
        try:
            existing_indexes = [index.name for index in self.pc.list_indexes()]
            
            if self.index_name not in existing_indexes:
                logger.info(f"Creating serverless index: {self.index_name}")
                self.pc.create_index(
                    name=self.index_name,
                    dimension=settings.VECTOR_DIMENSION,
                    metric="cosine",
                    spec=ServerlessSpec(
                        cloud=self.cloud,
                        region=self.region
                    )
                )
                logger.info(f"Serverless index created: {self.index_name}")
            else:
                logger.info(f"Using existing index: {self.index_name}")
                
        except Exception as e:
            logger.error(f"Error ensuring index exists: {e}")
            raise VectorServiceError(f"Failed to create/access index: {e}")

    async def search_places(
        self,
        query_embedding: List[float],
        top_k: int = 10,
        filter_dict: Optional[Dict[str, Any]] = None,
        province_filter: Optional[str] = None,
        min_rating: Optional[float] = None,
        place_ids: Optional[List[str]] = None
    ) -> List[Dict[str, Any]]:
        """
        Search for places using vector similarity with enhanced filtering.

        Args:
            query_embedding: Query vector embedding (768-dimensional)
            top_k: Number of results to return
            filter_dict: Optional metadata filters (e.g., {"province": "Hà Nội"})
            province_filter: Filter by specific province
            min_rating: Minimum rating filter (0.0-5.0)
            place_ids: Filter by specific place IDs

        Returns:
            List of matching places with metadata
        """
        # Build comprehensive filter
        combined_filter = filter_dict.copy() if filter_dict else {}

        # Add province filter
        if province_filter:
            combined_filter["province"] = {"$eq": province_filter}

        # Add rating filter
        if min_rating is not None:
            combined_filter["rating"] = {"$gte": min_rating}

        # Add place ID filter
        if place_ids:
            combined_filter["place_id"] = {"$in": place_ids}

        # Use async search
        return await self.search(
            vector=query_embedding,
            top_k=top_k,
            namespace=settings.PINECONE_DEFAULT_NAMESPACE,  # Use configured namespace for travel data
            filter_dict=combined_filter if combined_filter else None,
            include_metadata=True
        )

    async def upsert_vectors(self, vectors: List[Dict[str, Any]], namespace: Optional[str] = None) -> bool:
        """
        Upsert vectors to Pinecone index.

        Args:
            vectors: List of dicts with 'id', 'values', and 'metadata'
                     Format: [{"id": "...", "values": [...], "metadata": {...}}]
            namespace: Pinecone namespace (default: uses PINECONE_DEFAULT_NAMESPACE from settings)

        Returns:
            True if successful, False otherwise
        """
        try:
            # Use configured default namespace if not specified
            if namespace is None:
                namespace = settings.PINECONE_DEFAULT_NAMESPACE

            # Pinecone v6+ accepts dict format directly - no conversion needed
            await asyncio.to_thread(
                self.index.upsert,
                vectors=vectors,
                namespace=namespace
            )
            logger.info(f"Upserted {len(vectors)} vectors to namespace '{namespace}'")
            return True
        except Exception as e:
            logger.error(f"Failed to upsert vectors to namespace '{namespace}': {e}")
            return False

    async def delete_vectors(self, ids: List[str], namespace: Optional[str] = None) -> bool:
        """
        Delete vectors by IDs from Pinecone index.

        Args:
            ids: List of vector IDs to delete
            namespace: Pinecone namespace (default: uses PINECONE_DEFAULT_NAMESPACE from settings)

        Returns:
            True if successful, False otherwise
        """
        try:
            # Use configured default namespace if not specified
            if namespace is None:
                namespace = settings.PINECONE_DEFAULT_NAMESPACE

            self.index.delete(ids=ids, namespace=namespace)
            return True
        except Exception as e:
            logger.error(f"Failed to delete vectors {ids}: {e}")
            return False

    async def get_index_stats(self) -> Dict[str, Any]:
        """Get Pinecone index statistics as JSON-serializable dict."""
        try:
            stats = self.index.describe_index_stats()

            # Extract values from Pinecone stats object (may be dict or object)
            total_vectors = stats.get("total_vector_count", 0) if isinstance(stats, dict) else getattr(stats, 'total_vector_count', 0)
            dimension = stats.get("dimension", settings.VECTOR_DIMENSION) if isinstance(stats, dict) else getattr(stats, 'dimension', settings.VECTOR_DIMENSION)
            index_fullness = stats.get("index_fullness", 0.0) if isinstance(stats, dict) else getattr(stats, 'index_fullness', 0.0)

            # Handle namespaces (convert to serializable dict)
            namespaces_dict = {}
            namespaces = stats.get("namespaces", {}) if isinstance(stats, dict) else getattr(stats, 'namespaces', {})

            if namespaces:
                for ns_name, ns_data in namespaces.items():
                    if isinstance(ns_data, dict):
                        namespaces_dict[ns_name] = {"vector_count": ns_data.get("vector_count", 0)}
                    else:
                        # Handle Pinecone namespace object
                        namespaces_dict[ns_name] = {
                            "vector_count": getattr(ns_data, 'vector_count', 0)
                        }

            return {
                "total_vectors": total_vectors,
                "dimension": dimension,
                "index_fullness": index_fullness,
                "namespaces": namespaces_dict
            }
        except Exception as e:
            logger.error(f"Failed to get index stats: {e}")
            return {"error": str(e)}

    async def search(
        self,
        vector: List[float],
        top_k: int = 10,
        namespace: Optional[str] = None,
        filter_dict: Optional[Dict[str, Any]] = None,
        include_metadata: bool = True,
        attempt: int = 0,
        max_retries: int = 2
    ) -> List[Dict[str, Any]]:
        """
        Core vector search with Pinecone best practices and retry logic.

        Args:
            vector: Query embedding vector
            top_k: Number of results
            namespace: Namespace to search (default: uses PINECONE_DEFAULT_NAMESPACE from settings)
            filter_dict: Metadata filters
            include_metadata: Include metadata in results
            attempt: Current retry attempt (0-based)
            max_retries: Maximum number of retries (default: 2 for 3 total attempts)

        Returns:
            List of results with id, score, and metadata
        """
        try:
            # Use configured default namespace if not specified
            if namespace is None:
                namespace = settings.PINECONE_DEFAULT_NAMESPACE

            # Run blocking Pinecone call in thread pool (async-safe)
            response = await asyncio.to_thread(
                self.index.query,
                vector=vector,
                top_k=top_k,
                namespace=namespace,
                filter=filter_dict,
                include_metadata=include_metadata,
                include_values=False,  # Optimization: don't return vectors
                metric="cosine",       # Explicit metric
                show_progress=False    # Production mode
            )

            # Process results
            matches = response.get('matches', []) if isinstance(response, dict) else getattr(response, 'matches', [])
            results = []

            for match in matches:
                result = {
                    'id': match.get('id') if isinstance(match, dict) else getattr(match, 'id', None),
                    'score': match.get('score') if isinstance(match, dict) else getattr(match, 'score', 0.0),
                }

                if include_metadata:
                    result['metadata'] = match.get('metadata') if isinstance(match, dict) else getattr(match, 'metadata', {})

                results.append(result)

            logger.info(f"Search in namespace '{namespace}' returned {len(results)} results")
            return results

        except asyncio.TimeoutError as e:
            # Timeout: Retry with backoff (cold start or network blip)
            if attempt < max_retries:
                delay = 2 ** attempt  # Exponential backoff: 1s, 2s
                logger.warning(
                    f"[Node 2/6] Pinecone search timeout, retrying in {delay}s (attempt {attempt + 1}/{max_retries + 1})",
                    namespace=namespace,
                    error=str(e)
                )
                await asyncio.sleep(delay)
                return await self.search(
                    vector=vector,
                    top_k=top_k,
                    namespace=namespace,
                    filter_dict=filter_dict,
                    include_metadata=include_metadata,
                    attempt=attempt + 1,
                    max_retries=max_retries
                )
            else:
                logger.error(f"[Node 2/6] Pinecone search timeout - Max retries exhausted: {e}")
                raise VectorServiceError(f"Pinecone search timeout after {max_retries + 1} attempts: {e}")

        except Exception as e:
            # Check if it's a transient service error (503, etc)
            error_str = str(e).lower()
            is_transient = any(indicator in error_str for indicator in ["503", "unavailable", "temporarily", "cold start"])

            if is_transient and attempt < max_retries:
                delay = 2 ** attempt  # Exponential backoff: 1s, 2s
                logger.warning(
                    f"[Node 2/6] Pinecone transient error, retrying in {delay}s (attempt {attempt + 1}/{max_retries + 1})",
                    namespace=namespace,
                    error=str(e),
                    error_code="PINECONE_TRANSIENT"
                )
                await asyncio.sleep(delay)
                return await self.search(
                    vector=vector,
                    top_k=top_k,
                    namespace=namespace,
                    filter_dict=filter_dict,
                    include_metadata=include_metadata,
                    attempt=attempt + 1,
                    max_retries=max_retries
                )
            else:
                logger.error(f"[Node 2/6] Vector search in namespace '{namespace}' failed: {e}")
                raise VectorServiceError(f"Vector search failed: {e}")

    async def query_namespaces(
        self,
        vector: List[float],
        namespaces: List[str],
        top_k: int = 10,
        filter_dict: Optional[Dict[str, Any]] = None,
        include_metadata: bool = True
    ) -> List[Dict[str, Any]]:
        """
        Query across multiple namespaces efficiently using Pinecone's optimized method.

        Args:
            vector: Query embedding vector
            namespaces: List of namespaces to search
            top_k: Number of results per namespace
            filter_dict: Metadata filters
            include_metadata: Include metadata in results

        Returns:
            Combined results from all namespaces
        """
        try:
            response = await asyncio.to_thread(
                self.index.query_namespaces,
                vector=vector,
                namespaces=namespaces,
                metric="cosine",
                top_k=top_k,
                include_values=False,
                include_metadata=include_metadata,
                filter=filter_dict,
                show_progress=False
            )

            # Process results
            matches = response.get('matches', []) if isinstance(response, dict) else getattr(response, 'matches', [])
            results = []

            for match in matches:
                result = {
                    'id': match.get('id') if isinstance(match, dict) else getattr(match, 'id', None),
                    'score': match.get('score') if isinstance(match, dict) else getattr(match, 'score', 0.0),
                }

                if include_metadata:
                    result['metadata'] = match.get('metadata') if isinstance(match, dict) else getattr(match, 'metadata', {})

                results.append(result)

            logger.info(f"Multi-namespace query ({len(namespaces)} namespaces) returned {len(results)} results")

            # Log usage if available
            if hasattr(response, 'usage'):
                logger.info(f"Query usage: {response.usage}")

            return results

        except Exception as e:
            logger.error(f"Multi-namespace query failed: {e}")
            raise VectorServiceError(f"Multi-namespace query failed: {e}")

    async def health_check(self) -> bool:
        """
        Check if Pinecone service is healthy.

        Validates:
        - Connection to Pinecone
        - Index accessibility
        - Query functionality
        """
        try:
            # Create dummy vector for testing
            test_embedding = [0.1] * settings.VECTOR_DIMENSION

            # Test Pinecone query functionality
            await self.search(
                vector=test_embedding,
                top_k=1,
                namespace=None,  # Use configured default namespace
                include_metadata=False
            )

            # Check index stats
            stats = await self.get_index_stats()
            if "error" in stats:
                logger.error(f"Health check failed: index stats error")
                return False

            logger.info("Vector service health check passed")
            return True

        except Exception as e:
            logger.error(f"Pinecone health check failed: {e}")
            return False


_service_instance: Optional[VectorService] = None


def get_vector_service() -> VectorService:
    """Get singleton instance of VectorService."""
    global _service_instance
    if _service_instance is None:
        if not settings.PINECONE_API_KEY:
            raise VectorServiceError("Pinecone API key missing in environment variables")
        _service_instance = VectorService(
            api_key=settings.PINECONE_API_KEY,
            cloud=settings.PINECONE_CLOUD,
            region=settings.PINECONE_REGION,
            index_name=settings.PINECONE_INDEX_NAME
        )
    return _service_instance


__all__ = ["VectorService", "get_vector_service", "VectorServiceError"]
