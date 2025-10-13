"""
Data loading utilities for ViVu Vietnam AI Service.

This module handles loading and processing Vietnamese travel data into Pinecone vector database
using optimized chunking and minimal metadata approach for better search and cost efficiency.
"""

import json
import structlog
from typing import List, Dict, Any

from app.core.exceptions import DataLoadingError
from app.services.vector_service import get_vector_service
from app.services.embedding_service import get_embedding_service
from app.utils.helpers import chunk_list

logger = structlog.get_logger(__name__)


class PineconeDataLoader:
    """Data loader for travel information into Pinecone vector database with optimized chunking."""
    
    def __init__(self):
        """Initialize data loader with vector and embedding services."""
        self.vector_service = get_vector_service()
        self.embedding_service = get_embedding_service()
    
    async def load_places_from_json(
        self, 
        file_path: str,
        batch_size: int = 50
    ) -> int:
        """
        Load places from location_data.json file structure into Pinecone using optimized chunking.
        
        Args:
            file_path: Path to JSON file containing location data
            batch_size: Number of records to process in each batch
            
        Returns:
            int: Number of places loaded
        """
        try:
            logger.info(f"Loading places from {file_path} with optimized chunking")
            
            # Read JSON file
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Extract all places from provinces
            all_places = []
            if isinstance(data, list):
                for province_data in data:
                    province_name = province_data.get('province', '')
                    places = province_data.get('places', [])
                    
                    for place in places:
                        # Add province info to each place for context
                        place['province'] = province_name
                        all_places.append(place)
            
            if not all_places:
                logger.warning("No places found in JSON file")
                return 0
            
            logger.info(f"Found {len(all_places)} places to load")
            
            # Process places in batches
            total_loaded = 0
            place_chunks = chunk_list(all_places, batch_size)
            
            for chunk in place_chunks:
                loaded_count = await self._process_places_batch(chunk)
                total_loaded += loaded_count
            
            logger.info(f"Successfully loaded {total_loaded} places")
            return total_loaded
            
        except Exception as e:
            logger.error(f"Failed to load places: {e}")
            raise DataLoadingError(
                f"Failed to load places from {file_path}: {str(e)}",
                file_path=file_path,
                operation="load_places"
            )
    async def _process_places_batch(self, places: List[Dict[str, Any]]) -> int:
        """Process a batch of places from location_data.json structure using optimized chunking."""
        loaded_count = 0
        vectors_to_upsert = []
        
        for place_data in places:
            try:
                # Use embedding service to process place with chunking
                place_vectors = self.embedding_service.process_place(place_data)
                
                if place_vectors:
                    vectors_to_upsert.extend(place_vectors)
                    loaded_count += 1
                    
            except Exception as e:
                logger.warning(f"Failed to process place {place_data.get('name', 'unknown')}: {e}")
                continue
        
        # Batch upsert using VectorService (proper abstraction)
        if vectors_to_upsert:
            try:
                # Upsert in smaller batches to avoid rate limits
                batch_size = 100
                for i in range(0, len(vectors_to_upsert), batch_size):
                    batch = vectors_to_upsert[i:i + batch_size]

                    # Use service method instead of direct index access
                    success = await self.vector_service.upsert_vectors(
                        vectors=batch,
                        namespace=""  # Explicit default namespace
                    )

                    if not success:
                        logger.error(f"Failed to upsert batch {i//batch_size + 1}")
                        raise DataLoadingError("Batch upsert failed")

                    logger.debug(f"Upserted batch {i//batch_size + 1}: {len(batch)} vectors")

                logger.info(f"Successfully upserted {len(vectors_to_upsert)} vectors for {loaded_count} places")

            except Exception as e:
                logger.error(f"Failed to upsert vectors to Pinecone: {e}")
                raise
        
        return loaded_count

    async def insert_single_item(
        self, 
        item_type: str, 
        item_data: Dict[str, Any]
    ) -> bool:
        """
        Insert or update a single item in Pinecone using optimized embedding service.
        
        Args:
            item_type: Type of item ('place' is the main supported type)
            item_data: Item data dictionary
            
        Returns:
            bool: Success status
        """
        try:
            if item_type == "place":
                # Use embedding service to process the place
                place_vectors = self.embedding_service.process_place(item_data)
                
                if place_vectors:
                    # Upsert vectors to Pinecone
                    self.vector_service.index.upsert(vectors=place_vectors)
                    logger.info(f"Successfully inserted {len(place_vectors)} vectors for place")
                    return True
            else:
                logger.warning(f"Item type '{item_type}' not supported in optimized version. Use 'place' instead.")
                return False
                
            return False
            
        except Exception as e:
            logger.error(f"Failed to insert {item_type}: {e}")
            return False

    async def delete_item(self, content_id: str) -> bool:
        """
        Delete an item from Pinecone by ID.
        
        Args:
            content_id: ID of the item to delete
            
        Returns:
            bool: Success status
        """
        try:
            success = await self.vector_service.delete_embedding(content_id)
            logger.info(f"Deleted item {content_id}: {'success' if success else 'failed'}")
            return success
            
        except Exception as e:
            logger.error(f"Failed to delete item {content_id}: {e}")
            return False

    async def create_vector_index(self):
        """Create vector similarity index (handled by Pinecone service)."""
        try:
            await self.vector_service.create_vector_index()
            logger.info("Vector index verified with Pinecone service")
        except Exception as e:
            logger.error(f"Failed to verify Pinecone vector index: {e}")
            raise

    async def get_chunking_stats(self) -> Dict[str, Any]:
        """
        Get statistics about the chunking configuration and service.
        
        Returns:
            dict: Chunking and embedding service statistics
        """
        try:
            # Get embedding service stats
            embedding_stats = self.embedding_service.get_embedding_stats()
            
            # Get vector service stats
            vector_stats = await self.vector_service.get_index_stats()
            
            return {
                "embedding_service": embedding_stats,
                "vector_service": vector_stats,
                "chunking_enabled": True,
                "optimization": "minimal_metadata"
            }
            
        except Exception as e:
            logger.error(f"Failed to get chunking stats: {e}")
            return {"error": str(e)}


# Global data loader instance
_data_loader = None


def get_data_loader() -> PineconeDataLoader:
    """Get global data loader instance."""
    global _data_loader
    if _data_loader is None:
        _data_loader = PineconeDataLoader()
    return _data_loader


# Export optimized data loader
__all__ = [
    "PineconeDataLoader",
    "get_data_loader",
]