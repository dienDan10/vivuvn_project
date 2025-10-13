"""
Embedding service for Vietnamese travel data with optimized chunking and minimal metadata.

This service implements an optimized approach where Pinecone stores only search-essential
metadata while full place data is stored separately and fetched after search.
"""

import structlog
from typing import List, Dict, Optional, Any
import uuid

try:
    from langchain_text_splitters import RecursiveCharacterTextSplitter
except ImportError:
    RecursiveCharacterTextSplitter = None

try:
    from sentence_transformers import SentenceTransformer
except ImportError:
    SentenceTransformer = None

from app.core.config import settings

logger = structlog.get_logger(__name__)


class EmbeddingServiceError(Exception):
    """Custom exception for embedding service errors."""
    pass


class EmbeddingService:
    """
    Service for generating embeddings with minimal metadata approach.
    
    Architecture:
    - Pinecone = Search Index (minimal metadata only)
    - Separate Database/JSON = Full Data Store
    
    Flow:
    1. User query → Pinecone → Get place_ids + minimal metadata
    2. Fetch full place details from database using place_ids
    3. Return complete results to user
    """
    
    def __init__(self):
        """Initialize embedding service with model and text splitter."""
        logger.info("Initializing EmbeddingService...")
        
        # Check dependencies
        if not SentenceTransformer:
            raise EmbeddingServiceError("sentence-transformers library not available")
        if not RecursiveCharacterTextSplitter:
            raise EmbeddingServiceError("langchain library not available")
        
        # Load Vietnamese embedding model
        try:
            logger.info(f"Loading {settings.EMBEDDING_MODEL} model...")
            self.model = SentenceTransformer(settings.EMBEDDING_MODEL)
            logger.info(f"Model loaded successfully ({settings.VECTOR_DIMENSION} dims)")
        except Exception as e:
            logger.error(f"Failed to load embedding model: {e}")
            raise EmbeddingServiceError(f"Failed to load model: {e}")
        
        # Initialize LangChain text splitter
        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1200,
            chunk_overlap=100,
            separators=["\n\n", "\n", ". ", "。", "! ", "? ", " ", ""],
            length_function=len,
            is_separator_regex=False
        )
        
        logger.info("EmbeddingService initialized successfully")
    
    def process_place(self, place: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Process place and return Pinecone vectors with MINIMAL metadata.
        
        Args:
            place: Place data dictionary from location_data.json
            
        Returns:
            List[Dict]: List of vectors ready for Pinecone upsert
            
        Raises:
            EmbeddingServiceError: If processing fails
        """
        try:
            place_name = place.get('name', '').strip()
            if not place_name:
                logger.warning("Place missing name, skipping")
                return []
            
            logger.info(f"Processing: {place_name}")
            
            # Smart chunking based on description length
            chunks = self._smart_chunk(place)
            total_chunks = len(chunks)
            
            if len(place.get('description', '')) > 1200:
                logger.debug(f"{len(place.get('description', ''))} chars → {total_chunks} chunks")
            else:
                logger.debug(f"{len(place.get('description', ''))} chars → {total_chunks} chunk (no split)")
            
            vectors = []
            for chunk_index, chunk_text in enumerate(chunks):
                try:
                    # Create embedding text with context
                    embedding_text = self._create_embedding_text(place, chunk_text)
                    
                    # Generate embedding
                    embedding = self._generate_embedding(embedding_text)
                    
                    # Create minimal metadata (use province from place data)
                    province = place.get('province', 'Vietnam')
                    metadata = self._create_minimal_metadata(
                        place, chunk_text, chunk_index, total_chunks, province=province
                    )
                    
                    # Create vector for Pinecone
                    vector = {
                        "id": f"place_{place.get('googlePlaceId', uuid.uuid4())}_chunk_{chunk_index}",
                        "values": embedding,
                        "metadata": metadata
                    }
                    
                    vectors.append(vector)
                    
                except Exception as e:
                    logger.warning(f"Failed to create vector for chunk {chunk_index}: {e}")
                    continue
            
            logger.info(f"Generated {len(vectors)} vectors (minimal metadata)")
            return vectors
            
        except Exception as e:
            logger.error(f"Failed to process place {place.get('name', 'unknown')}: {e}")
            raise EmbeddingServiceError(f"Processing failed: {e}")
    
    def _smart_chunk(self, place: Dict[str, Any]) -> List[str]:
        """
        Chunk description if needed based on length.
        
        Args:
            place: Place data dictionary
            
        Returns:
            List[str]: List of text chunks
        """
        description = place.get('description', '').strip()
        
        # If no description or short description, return as single chunk
        if not description or len(description) <= 1200:
            return [description] if description else [place.get('name', '')]
        
        # Use LangChain splitter for long descriptions
        chunks = self.text_splitter.split_text(description)
        
        # Filter out very short chunks (< 100 chars)
        filtered_chunks = [chunk for chunk in chunks if len(chunk.strip()) >= 100]
        
        # If all chunks were filtered out, return original as single chunk
        if not filtered_chunks:
            return [description]
        
        return filtered_chunks
    
    def _create_embedding_text(self, place: Dict[str, Any], chunk_text: str) -> str:
        """
        Create embedding text with context for better semantic understanding.
        
        Args:
            place: Place data dictionary
            chunk_text: Text chunk to embed
            
        Returns:
            str: Formatted text for embedding
        """
        # Extract province from address or use default
        province = "Vietnam"  # Default
        address = place.get('address', '')
        if address:
            # Try to extract province from address
            address_parts = address.split(', ')
            if len(address_parts) >= 2:
                # Usually format: "Street, District, Province, Country"
                province = address_parts[-2] if len(address_parts) > 2 else address_parts[-1]
        
        # Create context-rich embedding text
        embedding_parts = [
            place.get('name', ''),
            f"Tỉnh/Thành: {province}",
            "",  # Empty line for separation
            chunk_text
        ]
        
        return "\n".join(part for part in embedding_parts if part)
    
    def _generate_embedding(self, text: str) -> List[float]:
        """
        Generate embedding using Vietnamese model (huyydangg/DEk21_hcmute_embedding).

        This model produces 768-dimensional embeddings optimized for Vietnamese text.

        Args:
            text: Text to embed

        Returns:
            List[float]: 768-dimensional embedding vector

        Raises:
            EmbeddingServiceError: If embedding generation fails
        """
        try:
            # Generate embedding with normalization
            embedding = self.model.encode(
                text,
                convert_to_tensor=False,
                normalize_embeddings=True
            )

            # Convert numpy array to list (required for Pinecone)
            embedding_list = embedding.tolist()

            # Verify dimension matches configuration
            if len(embedding_list) != settings.VECTOR_DIMENSION:
                raise EmbeddingServiceError(
                    f"Embedding dimension mismatch: model produced {len(embedding_list)} dimensions, "
                    f"but config expects {settings.VECTOR_DIMENSION}. "
                    f"Please update VECTOR_DIMENSION in .env to {len(embedding_list)}"
                )

            return embedding_list

        except EmbeddingServiceError:
            raise
        except Exception as e:
            logger.error(f"Failed to generate embedding: {e}")
            raise EmbeddingServiceError(f"Embedding generation failed: {e}")
    
    def _create_minimal_metadata(
        self, 
        place: Dict[str, Any], 
        chunk_text: str,
        chunk_index: int, 
        total_chunks: int,
        province: str = None
    ) -> Dict[str, Any]:
        """
        Create MINIMAL metadata for Pinecone (query-essential only).
        Full data is fetched separately after search.
        
        Args:
            place: Place data dictionary
            chunk_text: Text chunk
            chunk_index: Index of current chunk
            total_chunks: Total number of chunks
            province: Province name from parent data structure
            
        Returns:
            dict: Minimal metadata for Pinecone
        """
        # Use province from parent data structure (more reliable than parsing address)
        final_province = province or place.get('province', 'Vietnam')
        
        # Clean up province name if needed
        if final_province:
            final_province = final_province.strip()
            # Remove redundant text if present
            if 'Thành phố' in final_province and final_province != 'Thành phố Hồ Chí Minh':
                final_province = final_province.replace('Thành phố ', '')
        else:
            final_province = 'Vietnam'
        
        return {
            # === IDENTITY (required) ===
            "place_id": place.get('googlePlaceId', str(uuid.uuid4())),
            "name": place.get('name', '').strip() or "",
            
            # === CHUNKING INFO (required) ===
            "chunk_index": chunk_index,
            "total_chunks": total_chunks,
            
            # === LOCATION (for filtering/display) ===
            "latitude": float(place.get('latitude', 0) or 0),
            "longitude": float(place.get('longitude', 0) or 0),
            "province": final_province,
            
            # === FILTERING (for search filters) ===
            "rating": float(place.get('rating', 0) or 0),  # Convert None/null to 0.0
            
            # === SEARCH RELEVANCE (for preview) ===
            "chunk_text": chunk_text[:300] if chunk_text else "",  # Only 300 chars for snippet
        }
    
    def get_embedding_stats(self) -> Dict[str, Any]:
        """
        Get embedding service statistics.
        
        Returns:
            dict: Service statistics
        """
        return {
            "model_name": settings.EMBEDDING_MODEL,
            "vector_dimension": settings.VECTOR_DIMENSION,
            "chunk_size": 1200,
            "chunk_overlap": 100,
            "min_chunk_length": 100,
            "model_loaded": self.model is not None,
            "splitter_configured": self.text_splitter is not None
        }
    
    def health_check(self) -> bool:
        """
        Check if the embedding service is healthy.
        
        Returns:
            bool: True if service is healthy
        """
        try:
            # Test embedding generation
            test_embedding = self._generate_embedding("Test text for health check")
            return len(test_embedding) == settings.VECTOR_DIMENSION
        except Exception as e:
            logger.error(f"Health check failed: {e}")
            return False


# Global service instance
_embedding_service: Optional[EmbeddingService] = None


def get_embedding_service() -> EmbeddingService:
    """
    Get global embedding service instance.
    
    Returns:
        EmbeddingService: Service instance
        
    Raises:
        EmbeddingServiceError: If service cannot be initialized
    """
    global _embedding_service
    if _embedding_service is None:
        _embedding_service = EmbeddingService()
    return _embedding_service


__all__ = [
    "EmbeddingService", 
    "EmbeddingServiceError", 
    "get_embedding_service"
]