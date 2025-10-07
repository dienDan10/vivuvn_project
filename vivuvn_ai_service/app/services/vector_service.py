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
import logging
from app.core.config import settings

logger = logging.getLogger(__name__)

try:
    from pinecone import Pinecone, ServerlessSpec
    from pinecone.grpc import PineconeGRPC
except Exception:
    Pinecone = None
    ServerlessSpec = None
    PineconeGRPC = None

try:
    from sentence_transformers import SentenceTransformer  
except Exception:
    SentenceTransformer = None


class VectorServiceError(Exception):
    pass


class VectorService:
    """
    Simplified vector service focused on core Pinecone operations.
    
    This service handles low-level Pinecone operations like index management,
    vector search, and CRUD operations. For embedding generation with chunking
    and minimal metadata, use EmbeddingService instead.
    """
    
    def __init__(self, api_key: str, cloud: str = "aws", region: str = "us-east-1", index_name: str = "default", model_name: Optional[str] = None):
        if Pinecone is None:
            raise VectorServiceError("pinecone SDK is not installed")

        self.api_key = api_key
        self.cloud = cloud
        self.region = region
        self.index_name = index_name
        self.model_name = model_name or settings.EMBEDDING_MODEL
        self._embedder = SentenceTransformer(self.model_name) if SentenceTransformer else None

        # Initialize Pinecone with v6+ API (using gRPC for better performance)
        try:
            self.pc = PineconeGRPC(api_key=self.api_key) if PineconeGRPC else Pinecone(api_key=self.api_key)
        except Exception:
            # Fallback to standard Pinecone client
            self.pc = Pinecone(api_key=self.api_key)
        
        # Create serverless index if it doesn't exist
        self._ensure_index_exists()
        
        # Get index reference
        self.index = self.pc.Index(self.index_name)

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

    def generate_embedding(self, text: str) -> List[float]:
        """
        Generate embedding using Vietnamese model with dimension matching.
        
        Note: This method is kept for compatibility but the new EmbeddingService 
        is recommended for optimized chunking and minimal metadata.
        """
        if self._embedder is None:
            raise VectorServiceError("sentence-transformers is not available")
        
        # Generate embedding using sentence transformer
        emb = self._embedder.encode(text, convert_to_numpy=True)
        embedding = emb.tolist()
        
        # Pad or truncate to match target dimension
        target_dim = settings.VECTOR_DIMENSION
        current_dim = len(embedding)
        
        if current_dim < target_dim:
            # Pad with zeros to reach target dimension
            embedding.extend([0.0] * (target_dim - current_dim))
        elif current_dim > target_dim:
            # Truncate to target dimension
            embedding = embedding[:target_dim]
        
        return embedding

    async def upsert_vectors(self, vectors: List[Dict[str, Any]], namespace: str = "places") -> bool:
        """
        Upsert vectors to Pinecone index.
        
        Args:
            vectors: List of vector dictionaries with 'id', 'embedding', and 'metadata'
            namespace: Pinecone namespace to store vectors
        
        Returns:
            True if successful, False otherwise
        """
        try:
            upsert_data = [
                (v['id'], v['embedding'], v['metadata'])
                for v in vectors
            ]
            self.index.upsert(vectors=upsert_data, namespace=namespace)
            return True
        except Exception as e:
            logger.error(f"Failed to upsert vectors: {e}")
            return False

    async def delete_vectors(self, ids: List[str], namespace: str = "places") -> bool:
        """
        Delete vectors by IDs from Pinecone index.
        
        Args:
            ids: List of vector IDs to delete
            namespace: Pinecone namespace
        
        Returns:
            True if successful, False otherwise
        """
        try:
            self.index.delete(ids=ids, namespace=namespace)
            return True
        except Exception as e:
            logger.error(f"Failed to delete vectors {ids}: {e}")
            return False

    async def get_index_stats(self) -> Dict[str, Any]:
        """Get Pinecone index statistics."""
        try:
            stats = self.index.describe_index_stats()
            return {
                "total_vectors": stats.get("total_vector_count", 0),
                "dimension": stats.get("dimension", settings.VECTOR_DIMENSION),
                "index_fullness": stats.get("index_fullness", 0.0),
                "namespaces": stats.get("namespaces", {})
            }
        except Exception as e:
            logger.error(f"Failed to get index stats: {e}")
            return {"error": str(e)}

    def search(self, vector: List[float], top_k: int = 10, namespace: str = "places", 
              filter_dict: Optional[Dict[str, Any]] = None, 
              include_metadata: bool = True) -> List[Dict[str, Any]]:
        """
        Core vector search method for the optimized approach.
        
        Args:
            vector: Query embedding vector
            top_k: Number of results to return
            namespace: Pinecone namespace to search
            filter_dict: Optional metadata filter
            include_metadata: Whether to include metadata in results
        
        Returns:
            List of search results with id, score, and metadata
        """
        try:
            response = self.index.query(
                vector=vector,
                top_k=top_k,
                namespace=namespace,
                filter=filter_dict,
                include_metadata=include_metadata
            )
            
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
            
            return results
            
        except Exception as e:
            logger.error(f"Vector search failed: {e}")
            raise VectorServiceError(f"Vector search failed: {e}")

    async def health_check(self) -> bool:
        """
        Check if Pinecone service is healthy.
        
        Validates:
        - Connection to Pinecone
        - Index accessibility 
        - Vector dimension compatibility
        - Embedding model functionality (if available)
        """
        try:
            # Test 1: Check if embedding model works (if available)
            if self._embedder:
                test_embedding = self.generate_embedding("health check test")
                if len(test_embedding) != settings.VECTOR_DIMENSION:
                    logger.error(f"Health check failed: embedding dimension mismatch")
                    return False
            else:
                # Create dummy vector if no embedder
                test_embedding = [0.1] * settings.VECTOR_DIMENSION
            
            # Test 2: Test Pinecone query functionality
            self.search(
                vector=test_embedding, 
                top_k=1, 
                namespace="places",
                include_metadata=False
            )
            
            # Test 3: Check index stats
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
            index_name=settings.PINECONE_INDEX_NAME,
            model_name=settings.EMBEDDING_MODEL,
        )
    return _service_instance


__all__ = ["VectorService", "get_vector_service", "VectorServiceError"]
