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


class PineconeVectorService:
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
        if self._embedder is None:
            raise VectorServiceError("sentence-transformers is not available")
        emb = self._embedder.encode(text, convert_to_numpy=True)
        return emb.tolist()

    async def store_embedding(self, content_type: str, content_id: str, content_text: str, metadata: Optional[Dict[str, Any]] = None) -> str:
        vector_id = f"{content_type}:{content_id}"
        embedding = self.generate_embedding(content_text)
        meta = metadata.copy() if metadata else {}
        meta.update({"content_type": content_type, "content_id": content_id, "content_text": content_text})
        self.index.upsert([(vector_id, embedding, meta)])
        return vector_id

    async def delete_embedding(self, content_id: str) -> bool:
        """Delete embedding by content ID."""
        try:
            # Try different possible vector ID formats
            possible_ids = [
                content_id,
                f"destination:{content_id}",
                f"attraction:{content_id}",
                f"activity:{content_id}"
            ]
            
            deleted = False
            for vid in possible_ids:
                try:
                    self.index.delete(ids=[vid])
                    deleted = True
                    logger.info(f"Deleted vector with ID: {vid}")
                except Exception:
                    continue
            
            return deleted
            
        except Exception as e:
            logger.error(f"Failed to delete embedding {content_id}: {e}")
            return False

    async def get_index_stats(self) -> Dict[str, Any]:
        """Get Pinecone index statistics."""
        try:
            stats = self.index.describe_index_stats()
            return {
                "total_vectors": stats.get("total_vector_count", 0),
                "dimension": stats.get("dimension", settings.VECTOR_DIMENSION),
                "index_fullness": stats.get("index_fullness", 0.0)
            }
        except Exception as e:
            logger.error(f"Failed to get index stats: {e}")
            return {"error": str(e)}

    def create_vector_index(self) -> None:
        logger.info("Pinecone index verified/created: %s", self.index_name)

    def similarity_search(self, query_text: str, content_types: Optional[List[str]] = None, limit: int = 10, similarity_threshold: float = 0.0) -> List[Dict[str, Any]]:
        query_embedding = self.generate_embedding(query_text)
        try:
            resp = self.index.query(vector=query_embedding, top_k=limit, include_metadata=True)
        except Exception as e:
            logger.error("Pinecone query failed: %s", e)
            raise VectorServiceError(f"Pinecone query failed: {e}")

        matches = resp.get('matches', []) if isinstance(resp, dict) else getattr(resp, 'matches', [])
        results = []
        for m in matches:
            score = m.get('score') if isinstance(m, dict) else getattr(m, 'score', None)
            meta = m.get('metadata') if isinstance(m, dict) else getattr(m, 'metadata', {})
            vid = m.get('id') if isinstance(m, dict) else getattr(m, 'id', None)

            if content_types:
                mt = meta.get('content_type') if isinstance(meta, dict) else None
                if mt not in content_types:
                    continue

            if score is None or score < similarity_threshold:
                continue

            results.append({
                'id': vid,
                'score': float(score),
                'metadata': meta
            })

        return results

    def search_destinations(self, query_text: str, limit: int = 5) -> List[Dict[str, Any]]:
        results = self.similarity_search(query_text=query_text, content_types=["destination"], limit=limit)
        destinations = []
        for r in results:
            meta = r['metadata'] or {}
            destinations.append({
                'id': meta.get('content_id'),
                'name': meta.get('name') or meta.get('content_text', '')[:120],
                'region': meta.get('region'),
                'description': meta.get('description') or meta.get('content_text'),
                'coordinates': meta.get('coordinates'),
                'similarity_score': r['score'],
            })
        return destinations

    def search_activities(self, query_text: str, destination_id: Optional[str] = None, preferences: Optional[List[str]] = None, limit: int = 10) -> List[Dict[str, Any]]:
        enhanced_query = query_text
        if preferences:
            enhanced_query = enhanced_query + ' ' + ' '.join(preferences)

        results = self.similarity_search(query_text=enhanced_query, content_types=["activity", "attraction"], limit=limit * 2)
        activities = []
        for r in results:
            meta = r['metadata'] or {}
            if destination_id and str(meta.get('destination_id', '')) != str(destination_id):
                continue
            activities.append({
                'id': meta.get('content_id'),
                'type': meta.get('content_type'),
                'name': meta.get('name') or meta.get('content_text', '')[:120],
                'category': meta.get('category'),
                'description': meta.get('description') or meta.get('content_text'),
                'duration': meta.get('duration') or meta.get('duration_hours'),
                'cost_estimate': meta.get('cost_estimate') or meta.get('entrance_fee'),
                'destination_id': meta.get('destination_id'),
                'similarity_score': r['score'],
                'tags': meta.get('tags', []),
            })

        activities.sort(key=lambda x: x.get('similarity_score', 0), reverse=True)
        return activities[:limit]

    def get_contextual_information(self, destination: str, preferences: List[str], limit: int = 15) -> List[Dict[str, Any]]:
        query_text = f"{destination} travel guide {' '.join(preferences or [])}"
        results = self.similarity_search(query_text=query_text, limit=limit)
        context = []
        for r in results:
            meta = r['metadata'] or {}
            context.append({
                'content': meta.get('content_text') or '',
                'similarity_score': r['score'],
                'content_type': meta.get('content_type'),
                'metadata': meta,
            })
        return context

    def create_vector_index(self) -> None:
        logger.info("Pinecone index verified/created: %s", self.index_name)

    def health_check(self) -> bool:
        try:
            _ = self.generate_embedding("health check")
            _ = self.index.query(vector=[0.0] * settings.VECTOR_DIMENSION, top_k=1, include_metadata=False)
            return True
        except Exception as e:
            logger.error("Pinecone health check failed: %s", e)
            return False


_service_instance: Optional[PineconeVectorService] = None


def get_vector_service() -> PineconeVectorService:
    global _service_instance
    if _service_instance is None:
        if not settings.PINECONE_API_KEY:
            raise VectorServiceError("Pinecone API key missing in environment variables")
        _service_instance = PineconeVectorService(
            api_key=settings.PINECONE_API_KEY,
            cloud=settings.PINECONE_CLOUD,
            region=settings.PINECONE_REGION,
            index_name=settings.PINECONE_INDEX_NAME,
            model_name=settings.EMBEDDING_MODEL,
        )
    return _service_instance


__all__ = ["PineconeVectorService", "get_vector_service", "VectorServiceError"]
