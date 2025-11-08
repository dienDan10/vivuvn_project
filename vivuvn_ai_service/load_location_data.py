#!/usr/bin/env python3
"""
Optimized script to load location data from location_data.json into Pinecone
with chunking and minimal metadata approach.

This script uses the new EmbeddingService with LangChain chunking for better
semantic search and 90% smaller metadata for cost optimization.
"""

import asyncio
import os
import structlog
import sys
from pathlib import Path

current_dir = Path(__file__).parent
app_dir = current_dir / "app"
sys.path.insert(0, str(app_dir))

from app.services.data_management_service import get_data_management_service

# Configure structlog for script
structlog.configure(
    processors=[
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.dev.ConsoleRenderer()  # Human-readable output for scripts
    ],
    logger_factory=structlog.PrintLoggerFactory(),
    cache_logger_on_first_use=True,
)
logger = structlog.get_logger(__name__)


async def main():
    """Main function to load location data with optimized chunking."""
    try:
        logger.info("Starting optimized location data loading process...")
        
        location_data_path = "data/location_data.json"
        
        dm_service = get_data_management_service()

        logger.info("Vector services initialized (index auto-created if needed)")

        logger.info("Chunking configuration:")
        chunking_stats = await dm_service.get_stats()
        for key, value in chunking_stats.get('embedding_service', {}).items():
            logger.info(f"  {key}: {value}")

        logger.info("Loading places from location_data.json with optimized chunking...")
        logger.info("This will create multiple vectors per place if descriptions are long...")

        loaded_count = await dm_service.load_from_json_file(location_data_path)
        
        logger.info(f"Successfully processed {loaded_count} places")
        
        from app.services.pinecone_service import get_pinecone_service
        pinecone_service = get_pinecone_service()
        stats = await pinecone_service.get_index_stats()
        
        logger.info("Final Pinecone index statistics:")
        logger.info(f"  Total vectors: {stats.get('total_vectors', 'unknown')}")
        logger.info(f"  Dimension: {stats.get('dimension', 'unknown')}")
        logger.info(f"  Index fullness: {stats.get('index_fullness', 'unknown')}")
        
        if stats.get('total_vectors') and loaded_count:
            avg_chunks_per_place = stats['total_vectors'] / loaded_count
            logger.info(f"  Average chunks per place: {avg_chunks_per_place:.1f}")
    except Exception as e:
        logger.error(f"Error loading location data: {e}")
        raise


if __name__ == "__main__":
    asyncio.run(main())