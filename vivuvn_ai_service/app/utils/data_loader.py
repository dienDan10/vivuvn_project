"""
Data loading utilities for ViVu Vietnam AI Service.

This module handles loading and processing travel data into Pinecone vector database
for semantic search and retrieval operations.
"""

import json
import logging
from typing import List, Dict, Any, Optional
import uuid
from pathlib import Path

from app.core.exceptions import DataLoadingError
from app.services.vector_service import get_vector_service
from app.utils.helpers import (
    clean_text, normalize_destination_name, extract_cost_from_text,
    categorize_activity, parse_coordinates, create_slug, chunk_list
)

logger = logging.getLogger(__name__)


class PineconeDataLoader:
    """Data loader for travel information into Pinecone vector database."""
    
    def __init__(self):
        """Initialize data loader."""
        self.vector_service = get_vector_service()
    
    async def load_destinations_from_json(
        self, 
        file_path: str,
        batch_size: int = 50
    ) -> int:
        """
        Load destinations from JSON file into Pinecone.
        
        Args:
            file_path: Path to JSON file containing destinations
            batch_size: Number of records to process in each batch
            
        Returns:
            int: Number of destinations loaded
        """
        try:
            logger.info(f"Loading destinations from {file_path}")
            
            # Read JSON file
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            destinations_data = data.get('destinations', [])
            if not destinations_data:
                logger.warning("No destinations found in JSON file")
                return 0
            
            # Process destinations in batches
            total_loaded = 0
            destination_chunks = chunk_list(destinations_data, batch_size)
            
            for chunk in destination_chunks:
                loaded_count = await self._process_destination_batch(chunk)
                total_loaded += loaded_count
            
            logger.info(f"Successfully loaded {total_loaded} destinations")
            return total_loaded
            
        except Exception as e:
            logger.error(f"Failed to load destinations: {e}")
            raise DataLoadingError(
                f"Failed to load destinations from {file_path}: {str(e)}",
                file_path=file_path,
                operation="load_destinations"
            )
    
    async def _process_destination_batch(self, destinations: List[Dict[str, Any]]) -> int:
        """Process a batch of destinations."""
        loaded_count = 0
        
        for dest_data in destinations:
            try:
                # Create destination data
                destination = self._create_destination_data(dest_data)
                if destination:
                    # Store embedding in Pinecone
                    await self._store_destination_embedding_pinecone(destination)
                    loaded_count += 1
            
            except Exception as e:
                logger.warning(f"Failed to process destination {dest_data.get('name', 'unknown')}: {e}")
                continue
        
        return loaded_count
    
    def _create_destination_data(self, dest_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create destination data structure."""
        try:
            name = dest_data.get('name', '').strip()
            if not name:
                logger.warning("Destination missing name, skipping")
                return None
            
            # Normalize destination name
            normalized_name = normalize_destination_name(name)
            destination_id = str(uuid.uuid4())
            slug = create_slug(normalized_name)
            
            # Parse coordinates
            coordinates = None
            if 'coordinates' in dest_data:
                coordinates = dest_data['coordinates']
            elif 'lat' in dest_data and 'lng' in dest_data:
                coordinates = {"lat": dest_data['lat'], "lng": dest_data['lng']}
            
            # Create destination data
            destination = {
                "id": destination_id,
                "name": normalized_name,
                "slug": slug,
                "region": dest_data.get('region', 'Vietnam').strip(),
                "description": clean_text(dest_data.get('description', '')),
                "coordinates": coordinates,
                "best_time_to_visit": dest_data.get('best_time_to_visit'),
                "average_temperature": dest_data.get('average_temperature'),
                "timezone": dest_data.get('timezone', 'Asia/Ho_Chi_Minh'),
                "extra_data": dest_data.get('metadata', {})
            }
            
            logger.debug(f"Created destination: {normalized_name}")
            return destination
            
        except Exception as e:
            logger.error(f"Failed to create destination: {e}")
            return None
    
    async def _store_destination_embedding_pinecone(self, destination: Dict[str, Any]):
        """Store embedding for destination in Pinecone."""
        try:
            # Create content for embedding
            content_parts = [destination["name"]]
            
            if destination["description"]:
                content_parts.append(destination["description"])
            
            if destination["region"]:
                content_parts.append(f"Located in {destination['region']}")
            
            content_text = " ".join(content_parts)
            
            # Store embedding in Pinecone
            await self.vector_service.store_embedding(
                content_type="destination",
                content_id=destination["id"],
                content_text=content_text,
                metadata={
                    "name": destination["name"],
                    "region": destination["region"],
                    "slug": destination["slug"],
                    "description": destination["description"] or "",
                    "coordinates": destination["coordinates"],
                    "type": "destination"
                }
            )
            
        except Exception as e:
            logger.warning(f"Failed to store embedding for destination {destination['name']}: {e}")
    
    async def load_attractions_from_json(
        self, 
        file_path: str,
        batch_size: int = 100
    ) -> int:
        """
        Load attractions from JSON file into Pinecone.
        
        Args:
            file_path: Path to JSON file containing attractions
            batch_size: Number of records to process in each batch
            
        Returns:
            int: Number of attractions loaded
        """
        try:
            logger.info(f"Loading attractions from {file_path}")
            
            # Read JSON file
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Handle different JSON structures
            attractions_data = []
            if 'attractions' in data:
                attractions_data = data['attractions']
            elif 'destinations' in data:
                # Extract attractions from destinations
                for dest in data['destinations']:
                    if 'attractions' in dest:
                        for attraction in dest['attractions']:
                            attraction['destination_name'] = dest.get('name', '')
                            attractions_data.append(attraction)
            
            if not attractions_data:
                logger.warning("No attractions found in JSON file")
                return 0
            
            # Process attractions in batches
            total_loaded = 0
            attraction_chunks = chunk_list(attractions_data, batch_size)
            
            for chunk in attraction_chunks:
                loaded_count = await self._process_attraction_batch(chunk)
                total_loaded += loaded_count
            
            logger.info(f"Successfully loaded {total_loaded} attractions")
            return total_loaded
            
        except Exception as e:
            logger.error(f"Failed to load attractions: {e}")
            raise DataLoadingError(
                f"Failed to load attractions from {file_path}: {str(e)}",
                file_path=file_path,
                operation="load_attractions"
            )
    
    async def _process_attraction_batch(self, attractions: List[Dict[str, Any]]) -> int:
        """Process a batch of attractions."""
        loaded_count = 0
        
        for attr_data in attractions:
            try:
                # Create attraction data
                attraction = self._create_attraction_data(attr_data)
                if attraction:
                    # Store embedding in Pinecone
                    await self._store_attraction_embedding_pinecone(attraction)
                    loaded_count += 1
            
            except Exception as e:
                logger.warning(f"Failed to process attraction {attr_data.get('name', 'unknown')}: {e}")
                continue
        
        return loaded_count
    
    def _create_attraction_data(self, attr_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create attraction data structure."""
        try:
            name = attr_data.get('name', '').strip()
            if not name:
                logger.warning("Attraction missing name, skipping")
                return None
            
            attraction_id = str(uuid.uuid4())
            destination_name = attr_data.get('destination_name', '')
            
            # Parse coordinates
            coordinates = None
            if 'coordinates' in attr_data:
                coordinates = attr_data['coordinates']
            elif 'lat' in attr_data and 'lng' in attr_data:
                coordinates = {"lat": attr_data['lat'], "lng": attr_data['lng']}
            
            # Extract cost information
            entrance_fee = extract_cost_from_text(attr_data.get('cost', '')) or \
                         extract_cost_from_text(attr_data.get('entrance_fee', ''))
            
            # Categorize attraction
            category = categorize_activity(name, attr_data.get('description', ''))
            
            # Create attraction data
            attraction = {
                "id": attraction_id,
                "name": clean_text(name),
                "destination_name": destination_name,
                "category": category,
                "description": clean_text(attr_data.get('description', '')),
                "address": clean_text(attr_data.get('address', '')),
                "coordinates": coordinates,
                "opening_hours": attr_data.get('opening_hours'),
                "entrance_fee": entrance_fee,
                "duration_hours": attr_data.get('duration_hours'),
                "rating": attr_data.get('rating'),
                "tags": attr_data.get('tags', []),
                "extra_data": attr_data.get('metadata', {})
            }
            
            logger.debug(f"Created attraction: {name}")
            return attraction
            
        except Exception as e:
            logger.error(f"Failed to create attraction: {e}")
            return None
    
    async def _store_attraction_embedding_pinecone(self, attraction: Dict[str, Any]):
        """Store embedding for attraction in Pinecone."""
        try:
            # Create content for embedding
            content_parts = [attraction["name"], f"Category: {attraction['category']}"]
            
            if attraction["description"]:
                content_parts.append(attraction["description"])
            
            if attraction["address"]:
                content_parts.append(f"Located at {attraction['address']}")
            
            if attraction["tags"]:
                content_parts.append(f"Tags: {', '.join(attraction['tags'])}")
            
            content_text = " ".join(content_parts)
            
            # Store embedding in Pinecone
            await self.vector_service.store_embedding(
                content_type="attraction",
                content_id=attraction["id"],
                content_text=content_text,
                metadata={
                    "name": attraction["name"],
                    "category": attraction["category"],
                    "address": attraction["address"] or "",
                    "tags": attraction["tags"] or [],
                    "description": attraction["description"] or "",
                    "destination_name": attraction["destination_name"],
                    "entrance_fee": attraction["entrance_fee"],
                    "duration_hours": attraction["duration_hours"],
                    "type": "attraction"
                }
            )
            
        except Exception as e:
            logger.warning(f"Failed to store embedding for attraction {attraction['name']}: {e}")
    
    async def load_activities_from_json(
        self, 
        file_path: str,
        batch_size: int = 100
    ) -> int:
        """
        Load activities from JSON file into Pinecone.
        
        Args:
            file_path: Path to JSON file containing activities
            batch_size: Number of records to process in each batch
            
        Returns:
            int: Number of activities loaded
        """
        try:
            logger.info(f"Loading activities from {file_path}")
            
            # Read JSON file
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Handle different JSON structures
            activities_data = []
            if 'activities' in data:
                activities_data = data['activities']
            elif 'destinations' in data:
                # Extract activities from destinations
                for dest in data['destinations']:
                    if 'activities' in dest:
                        for activity in dest['activities']:
                            activity['destination_name'] = dest.get('name', '')
                            activities_data.append(activity)
            
            if not activities_data:
                logger.warning("No activities found in JSON file")
                return 0
            
            # Process activities in batches
            total_loaded = 0
            activity_chunks = chunk_list(activities_data, batch_size)
            
            for chunk in activity_chunks:
                loaded_count = await self._process_activity_batch(chunk)
                total_loaded += loaded_count
            
            logger.info(f"Successfully loaded {total_loaded} activities")
            return total_loaded
            
        except Exception as e:
            logger.error(f"Failed to load activities: {e}")
            raise DataLoadingError(
                f"Failed to load activities from {file_path}: {str(e)}",
                file_path=file_path,
                operation="load_activities"
            )
    
    async def _process_activity_batch(self, activities: List[Dict[str, Any]]) -> int:
        """Process a batch of activities."""
        loaded_count = 0
        
        for activity_data in activities:
            try:
                # Create activity data
                activity = self._create_activity_data(activity_data)
                if activity:
                    # Store embedding in Pinecone
                    await self._store_activity_embedding_pinecone(activity)
                    loaded_count += 1
            
            except Exception as e:
                logger.warning(f"Failed to process activity {activity_data.get('name', 'unknown')}: {e}")
                continue
        
        return loaded_count
    
    def _create_activity_data(self, activity_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create activity data structure."""
        try:
            name = activity_data.get('name', '').strip()
            if not name:
                logger.warning("Activity missing name, skipping")
                return None
            
            activity_id = str(uuid.uuid4())
            destination_name = activity_data.get('destination_name', '')
            
            # Extract cost information
            cost_estimate = extract_cost_from_text(activity_data.get('cost', '')) or \
                           extract_cost_from_text(activity_data.get('cost_estimate', ''))
            
            # Categorize activity
            category = categorize_activity(name, activity_data.get('description', ''))
            
            # Create activity data
            activity = {
                "id": activity_id,
                "name": clean_text(name),
                "destination_name": destination_name,
                "category": category,
                "description": clean_text(activity_data.get('description', '')),
                "duration": activity_data.get('duration'),
                "cost_estimate": cost_estimate,
                "difficulty_level": activity_data.get('difficulty_level'),
                "best_time": activity_data.get('best_time'),
                "group_size_min": activity_data.get('group_size_min'),
                "group_size_max": activity_data.get('group_size_max'),
                "tags": activity_data.get('tags', []),
                "requirements": activity_data.get('requirements', []),
                "extra_data": activity_data.get('metadata', {})
            }
            
            logger.debug(f"Created activity: {name}")
            return activity
            
        except Exception as e:
            logger.error(f"Failed to create activity: {e}")
            return None
    
    async def _store_activity_embedding_pinecone(self, activity: Dict[str, Any]):
        """Store embedding for activity in Pinecone."""
        try:
            # Create content for embedding
            content_parts = [activity["name"], f"Category: {activity['category']}"]
            
            if activity["description"]:
                content_parts.append(activity["description"])
            
            if activity["duration"]:
                content_parts.append(f"Duration: {activity['duration']}")
            
            if activity["tags"]:
                content_parts.append(f"Tags: {', '.join(activity['tags'])}")
            
            if activity["difficulty_level"]:
                content_parts.append(f"Difficulty: {activity['difficulty_level']}")
            
            content_text = " ".join(content_parts)
            
            # Store embedding in Pinecone
            await self.vector_service.store_embedding(
                content_type="activity",
                content_id=activity["id"],
                content_text=content_text,
                metadata={
                    "name": activity["name"],
                    "category": activity["category"],
                    "duration": activity["duration"] or "",
                    "tags": activity["tags"] or [],
                    "description": activity["description"] or "",
                    "destination_name": activity["destination_name"],
                    "cost_estimate": activity["cost_estimate"],
                    "difficulty_level": activity["difficulty_level"] or "",
                    "best_time": activity["best_time"] or "",
                    "type": "activity"
                }
            )
            
        except Exception as e:
            logger.warning(f"Failed to store embedding for activity {activity['name']}: {e}")

    async def insert_single_item(
        self, 
        item_type: str, 
        item_data: Dict[str, Any]
    ) -> bool:
        """
        Insert or update a single item in Pinecone.
        
        Args:
            item_type: Type of item ('destination', 'attraction', 'activity')
            item_data: Item data dictionary
            
        Returns:
            bool: Success status
        """
        try:
            if item_type == "destination":
                destination = self._create_destination_data(item_data)
                if destination:
                    await self._store_destination_embedding_pinecone(destination)
                    return True
                    
            elif item_type == "attraction":
                attraction = self._create_attraction_data(item_data)
                if attraction:
                    await self._store_attraction_embedding_pinecone(attraction)
                    return True
                    
            elif item_type == "activity":
                activity = self._create_activity_data(item_data)
                if activity:
                    await self._store_activity_embedding_pinecone(activity)
                    return True
            
            else:
                raise ValueError(f"Unsupported item type: {item_type}")
                
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


# Global data loader instance
_data_loader = None


def get_data_loader() -> PineconeDataLoader:
    """Get global data loader instance."""
    global _data_loader
    if _data_loader is None:
        _data_loader = PineconeDataLoader()
    return _data_loader


# Export data loader and utilities
__all__ = [
    "PineconeDataLoader",
    "get_data_loader",
]