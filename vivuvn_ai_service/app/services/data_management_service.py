"""
Data management service for ViVu Vietnam AI Service.

This service orchestrates data operations (insert, update, delete) by coordinating
embedding generation and Pinecone vector storage. It replaces the previous data_loader
utility and implements proper 3-layer architecture.

Responsibilities:
- Insert/update place data with embedding generation
- Delete places with all associated vectors
- Batch file processing from JSON
- Statistics aggregation
"""

import json
import structlog
from typing import List, Dict, Any, Optional

from app.core.exceptions import DataLoadingError
from app.core.config import settings
from app.services.pinecone_service import get_pinecone_service
from app.services.embedding_service import get_embedding_service
from app.utils.helpers import chunk_list

logger = structlog.get_logger(__name__)


class DataManagementService:
    """
    Service for managing place data in Pinecone vector database.

    Orchestrates embedding generation and vector storage operations. Handles:
    - Single place insert/update
    - Batch place processing
    - Place deletion with all chunks
    - JSON file loading with province structure

    This service fixes issues from the previous data_loader:
    - Delete operation now handles unlimited chunks (not just 10)
    - Proper error handling and logging
    - Better separation of concerns
    """

    def __init__(self):
        """Initialize with embedding and pinecone services."""
        self.pinecone_service = get_pinecone_service()
        self.embedding_service = get_embedding_service()
        logger.info("DataManagementService initialized")

    async def upsert_place(self, place_data: Dict[str, Any]) -> bool:
        """
        Upsert a single place in Pinecone (insert or update).

        This method uses Pinecone's upsert operation which automatically handles:
        - Inserting new places
        - Overwriting existing places (if googlePlaceId already exists)

        The upsert operation will:
        1. Generate embeddings with chunking
        2. Upsert vectors to Pinecone (automatically overwrites old vectors)

        Args:
            place_data: Place data dictionary with fields:
                - name (str): Place name
                - googlePlaceId (str): Google Place ID
                - description (str): Full description (will be chunked)
                - address (str): Street address
                - latitude (float): Geographic latitude
                - longitude (float): Geographic longitude
                - rating (float): Rating 0.0-5.0
                - province (str): Province/region name

        Returns:
            bool: True if successfully upserted, False otherwise

        Raises:
            Exception: If critical error occurs during upsert
        """
        try:
            place_name = place_data.get("name", "unknown")
            place_id = place_data.get("googlePlaceId")

            logger.info(
                "Upserting place",
                place_name=place_name,
                place_id=place_id,
            )

            # Generate embeddings with chunking
            place_vectors = await self.embedding_service.process_place(place_data)

            if not place_vectors:
                logger.warning(
                    "No vectors generated for place",
                    place_name=place_name,
                    place_id=place_id,
                )
                return False

            # Upsert to Pinecone (handles both insert and update automatically)
            success = await self.pinecone_service.upsert_vectors(vectors=place_vectors)

            if success:
                logger.info(
                    "Successfully upserted place",
                    place_id=place_id,
                    place_name=place_name,
                    vectors_count=len(place_vectors),
                )
            else:
                logger.error(
                    "Failed to upsert vectors for place",
                    place_id=place_id,
                    place_name=place_name,
                )

            return success

        except Exception as e:
            logger.error(
                "Failed to upsert place",
                place_name=place_data.get("name", "unknown"),
                place_id=place_data.get("googlePlaceId"),
                error=str(e),
            )
            return False

    async def insert_places_batch(
        self, places: List[Dict[str, Any]], batch_size: int = 50
    ) -> int:
        """
        Insert multiple places in batches.

        This method processes places in batches to manage memory and API rate limits.
        Individual place failures don't stop batch processing.

        Args:
            places: List of place data dictionaries
            batch_size: Number of places to process per batch (default: 50)

        Returns:
            int: Number of places successfully inserted

        Raises:
            DataLoadingError: If batch upsert fails (critical error)
        """
        logger.info(
            "Batch insert started",
            total_places=len(places),
            batch_size=batch_size,
        )

        total_loaded = 0
        place_chunks = chunk_list(places, batch_size)

        for i, chunk in enumerate(place_chunks, 1):
            try:
                loaded_count = await self._process_places_batch(chunk)
                total_loaded += loaded_count
                logger.info(
                    "Batch processed",
                    batch_num=i,
                    batch_size=len(chunk),
                    loaded=loaded_count,
                )
            except Exception as e:
                logger.error(
                    "Batch processing failed",
                    batch_num=i,
                    error=str(e),
                )
                # Continue processing remaining batches

        logger.info(
            "Batch insert completed",
            total_loaded=total_loaded,
            total_batches=len(list(place_chunks)),
        )
        return total_loaded

    async def _process_places_batch(self, places: List[Dict[str, Any]]) -> int:
        """
        Process a batch of places (internal method).

        Generates embeddings for all places, then upserts vectors in sub-batches
        to Pinecone to manage API rate limits.

        Args:
            places: List of place dictionaries to process

        Returns:
            int: Number of places successfully processed

        Raises:
            DataLoadingError: If batch upsert fails
        """
        loaded_count = 0
        vectors_to_upsert = []

        # Generate embeddings for all places in batch
        for place_data in places:
            try:
                place_vectors = await self.embedding_service.process_place(place_data)
                if place_vectors:
                    vectors_to_upsert.extend(place_vectors)
                    loaded_count += 1
            except Exception as e:
                logger.warning(
                    "Failed to process place",
                    place_name=place_data.get("name", "unknown"),
                    error=str(e),
                )
                continue

        # Batch upsert to Pinecone with sub-batching
        if vectors_to_upsert:
            batch_size = 100
            for i in range(0, len(vectors_to_upsert), batch_size):
                batch = vectors_to_upsert[i : i + batch_size]
                try:
                    success = await self.pinecone_service.upsert_vectors(vectors=batch)

                    if not success:
                        logger.error(
                            "Failed to upsert batch",
                            batch_num=i // batch_size + 1,
                        )
                        raise DataLoadingError("Batch upsert failed")

                    logger.debug(
                        "Batch upserted",
                        batch_num=i // batch_size + 1,
                        vectors_count=len(batch),
                    )
                except DataLoadingError:
                    raise
                except Exception as e:
                    logger.error(
                        "Error upserting batch",
                        batch_num=i // batch_size + 1,
                        error=str(e),
                    )
                    raise DataLoadingError(f"Batch upsert failed: {str(e)}")

            logger.info(
                "Batch upsert completed",
                total_vectors=len(vectors_to_upsert),
                total_places=loaded_count,
            )

        return loaded_count

    async def delete_place(self, place_id: str) -> bool:
        """
        Delete a place by ID (deletes all associated chunks).

        Args:
            place_id: Google Place ID to delete

        Returns:
            bool: True if deletion succeeded, False otherwise

        Raises:
            DataLoadingError: If critical error occurs
        """
        try:
            logger.info("Deleting place", place_id=place_id)

            namespace = settings.PINECONE_DEFAULT_NAMESPACE

            # Try to get index stats to understand the data
            vector_ids_to_delete = []

            # Query Pinecone using the index to find all chunks
            # We'll use a filter on place_id in metadata
            query_results = await self.pinecone_service.query_by_metadata(
                place_id=place_id, namespace=namespace
            )

            if query_results:
                vector_ids_to_delete = query_results
                logger.info(
                    "Found vectors to delete",
                    place_id=place_id,
                    vectors_count=len(vector_ids_to_delete),
                )

            if not vector_ids_to_delete:
                logger.warning("No vectors found to delete", place_id=place_id)
                return True  # Consider it a success if nothing to delete

            # Delete vectors
            success = await self.pinecone_service.delete_vectors(vector_ids_to_delete)

            if success:
                logger.info(
                    "Successfully deleted place",
                    place_id=place_id,
                    vectors_deleted=len(vector_ids_to_delete),
                )
            else:
                logger.error("Failed to delete place vectors", place_id=place_id)

            return success

        except Exception as e:
            logger.error(
                "Failed to delete place",
                place_id=place_id,
                error=str(e),
            )
            return False

    async def load_from_json_file(
        self, file_path: str, batch_size: int = 50
    ) -> int:
        """
        Load places from JSON file with province structure.

        Expected JSON format:
        ```json
        [
            {
                "province": "Hà Nội",
                "places": [
                    {
                        "name": "Hoan Kiem Lake",
                        "googlePlaceId": "ChIJ...",
                        "description": "...",
                        "address": "...",
                        "latitude": 21.0285,
                        "longitude": 105.8537,
                        "rating": 4.8
                    }
                ]
            }
        ]
        ```

        Args:
            file_path: Path to JSON file
            batch_size: Number of places per batch (default: 50)

        Returns:
            int: Total number of places successfully loaded

        Raises:
            DataLoadingError: If file cannot be read or processed
        """
        try:
            logger.info(
                "Loading places from JSON file",
                file_path=file_path,
            )

            # Read JSON file
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Extract places from provinces structure
            all_places = []
            if isinstance(data, list):
                for province_data in data:
                    province_name = province_data.get("province", "")
                    places = province_data.get("places", [])

                    for place in places:
                        # Add province info to each place for context
                        place["province"] = province_name
                        all_places.append(place)

            if not all_places:
                logger.warning("No places found in JSON file", file_path=file_path)
                return 0

            logger.info(
                "Extracted places from file",
                file_path=file_path,
                total_places=len(all_places),
            )

            # Process in batches
            total_loaded = await self.insert_places_batch(all_places, batch_size)

            logger.info(
                "Successfully loaded from JSON file",
                file_path=file_path,
                total_loaded=total_loaded,
            )
            return total_loaded

        except Exception as e:
            logger.error(
                "Failed to load from JSON file",
                file_path=file_path,
                error=str(e),
            )
            raise DataLoadingError(
                f"Failed to load from {file_path}: {str(e)}", file_path=file_path
            )

    async def get_stats(self) -> Dict[str, Any]:
        """
        Get combined statistics from embedding and Pinecone services.

        Returns statistics about:
        - Embedding service configuration and stats
        - Pinecone index status
        - Chunking configuration

        Returns:
            dict: Combined statistics from both services

        Example:
            ```python
            stats = await service.get_stats()
            # {
            #     "embedding_service": {...},
            #     "pinecone_service": {...},
            #     "chunking_enabled": True,
            #     "optimization": "minimal_metadata"
            # }
            ```
        """
        try:
            embedding_stats = self.embedding_service.get_embedding_stats()
            pinecone_stats = await self.pinecone_service.get_index_stats()

            return {
                "embedding_service": embedding_stats,
                "pinecone_service": pinecone_stats,
                "chunking_enabled": True,
                "optimization": "minimal_metadata",
            }
        except Exception as e:
            logger.error(
                "Failed to get stats",
                error=str(e),
            )
            return {"error": str(e)}

    async def health_check(self) -> bool:
        """
        Check if the data management service is healthy.

        Verifies both embedding service and Pinecone service are operational.

        Returns:
            bool: True if service is healthy
        """
        try:
            embedding_healthy = await self.embedding_service.health_check()
            pinecone_healthy = await self.pinecone_service.health_check()

            is_healthy = embedding_healthy and pinecone_healthy

            logger.info(
                "Health check completed",
                embedding_healthy=embedding_healthy,
                pinecone_healthy=pinecone_healthy,
                overall_healthy=is_healthy,
            )

            return is_healthy
        except Exception as e:
            logger.error(
                "Health check failed",
                error=str(e),
            )
            return False


# Global singleton instance
_service_instance: Optional[DataManagementService] = None


def get_data_management_service() -> DataManagementService:
    """
    Get singleton instance of DataManagementService.

    Creates the service on first call and reuses the same instance
    for all subsequent calls.

    Returns:
        DataManagementService: Singleton instance

    Raises:
        DataLoadingError: If service cannot be initialized
    """
    global _service_instance
    if _service_instance is None:
        _service_instance = DataManagementService()
    return _service_instance


__all__ = [
    "DataManagementService",
    "get_data_management_service",
]
