"""
Data management API routes for ViVu Vietnam AI Service.

This module provides endpoints for managing travel data in Pinecone vector database.
"""

import logging
from typing import Dict, Any, List
from fastapi import APIRouter, HTTPException, UploadFile, File, Form
from fastapi.responses import JSONResponse
import json

from app.utils.data_loader import get_data_loader
from app.core.exceptions import DataLoadingError
from app.api.schemas import (
    DataInsertRequest,
    DataInsertResponse,
    DataDeleteRequest,
    DataDeleteResponse,
    DataBatchUploadResponse
)

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/insert", response_model=DataInsertResponse)
async def insert_data_item(request: DataInsertRequest):
    """
    Insert or update a single data item in Pinecone using optimized embedding service.
    
    Args:
        request: Data item to insert (currently supports 'place' type)
        
    Returns:
        DataInsertResponse: Success status and item ID
    """
    try:
        data_loader = get_data_loader()
        
        # Only support 'place' type in optimized version
        if request.item_type != "place":
            raise HTTPException(
                status_code=400,
                detail="Only 'place' item type is supported in optimized version"
            )
        
        success = await data_loader.insert_single_item(
            item_type=request.item_type,
            item_data=request.data
        )
        
        if success:
            return DataInsertResponse(
                success=True,
                message=f"Successfully inserted {request.item_type}",
                item_id=request.data.get("googlePlaceId") or request.data.get("id"),
                item_type=request.item_type
            )
        else:
            raise HTTPException(
                status_code=400,
                detail=f"Failed to insert {request.item_type}"
            )
            
    except DataLoadingError as e:
        logger.error(f"Data loading error: {e}")
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.error(f"Unexpected error inserting data: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@router.delete("/delete", response_model=DataDeleteResponse)
async def delete_data_item(request: DataDeleteRequest):
    """
    Delete a data item from Pinecone by ID.
    
    Args:
        request: Item ID to delete
        
    Returns:
        DataDeleteResponse: Success status
    """
    try:
        data_loader = get_data_loader()
        
        success = await data_loader.delete_item(request.item_id)
        
        if success:
            return DataDeleteResponse(
                success=True,
                message=f"Successfully deleted item {request.item_id}",
                item_id=request.item_id
            )
        else:
            raise HTTPException(
                status_code=404,
                detail=f"Item {request.item_id} not found or could not be deleted"
            )
            
    except Exception as e:
        logger.error(f"Error deleting data: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@router.post("/batch-upload", response_model=DataBatchUploadResponse)
async def batch_upload_from_json(
    file: UploadFile = File(..., description="JSON file containing travel data"),
    data_type: str = Form(..., description="Type of data: 'places' (optimized for Vietnamese locations)")
):
    """
    Batch upload travel data from JSON file using optimized chunking.
    
    Args:
        file: JSON file containing travel data
        data_type: Type of data to upload (currently supports 'places' only)
        
    Returns:
        DataBatchUploadResponse: Upload results
    """
    try:
        # Validate data type - only support 'places' in optimized version
        if data_type != "places":
            raise HTTPException(
                status_code=400,
                detail="Only 'places' data type is supported in optimized version"
            )
        
        # Save uploaded file temporarily
        import tempfile
        import os
        
        with tempfile.NamedTemporaryFile(mode='wb', delete=False, suffix='.json') as tmp_file:
            content = await file.read()
            tmp_file.write(content)
            temp_file_path = tmp_file.name
        
        try:
            data_loader = get_data_loader()
            
            # Load places data with optimized chunking
            loaded_count = await data_loader.load_places_from_json(temp_file_path)
            
            return DataBatchUploadResponse(
                success=True,
                message=f"Successfully uploaded {loaded_count} {data_type} with optimized chunking",
                uploaded_count=loaded_count,
                data_type=data_type,
                filename=file.filename
            )
            
        finally:
            # Clean up temporary file
            if os.path.exists(temp_file_path):
                os.unlink(temp_file_path)
                
    except DataLoadingError as e:
        logger.error(f"Data loading error: {e}")
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.error(f"Error in batch upload: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@router.post("/load-location-data")
async def load_location_data_file():
    """
    Load data from the local location_data.json file.
    This is a one-time operation to populate the database.
    
    Returns:
        dict: Load operation results
    """
    try:
        data_loader = get_data_loader()
        
        # Path to the location data file
        file_path = "d:/FU/SEP490/vivuvn_project/vivuvn_api/vivuvn_api/Data/location_data.json"
        
        # Check if file exists
        import os
        if not os.path.exists(file_path):
            raise HTTPException(
                status_code=404,
                detail="location_data.json file not found"
            )
        
        # Load places from the location data file
        loaded_count = await data_loader.load_places_from_json(file_path)
        
        return {
            "success": True,
            "message": f"Successfully loaded {loaded_count} places from location_data.json",
            "loaded_count": loaded_count,
            "data_type": "places",
            "source_file": "location_data.json"
        }
        
    except DataLoadingError as e:
        logger.error(f"Data loading error: {e}")
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.error(f"Error loading location data: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/initialize-index")
async def initialize_vector_index():
    """
    Initialize or verify the Pinecone vector index.
    
    Returns:
        dict: Index initialization status
    """
    try:
        data_loader = get_data_loader()
        await data_loader.create_vector_index()
        
        return {
            "success": True,
            "message": "Vector index initialized successfully"
        }
        
    except Exception as e:
        logger.error(f"Error initializing vector index: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/stats")
async def get_data_stats():
    """
    Get statistics about data in Pinecone.
    
    Returns:
        dict: Data statistics
    """
    try:
        from app.services.vector_service import get_vector_service
        vector_service = get_vector_service()
        
        # Get index stats (if available)
        stats = await vector_service.get_index_stats()
        
        return {
            "success": True,
            "message": "Data statistics retrieved",
            "stats": stats
        }
        
    except Exception as e:
        logger.error(f"Error getting data stats: {e}")
        return {
            "success": False,
            "message": "Could not retrieve statistics",
            "error": str(e)
        }


@router.get("/chunking-stats")
async def get_chunking_stats():
    """
    Get statistics about chunking configuration and embedding service.
    
    Returns:
        dict: Chunking statistics and configuration
    """
    try:
        data_loader = get_data_loader()
        
        # Get chunking stats
        stats = await data_loader.get_chunking_stats()
        
        return {
            "success": True,
            "message": "Chunking statistics retrieved",
            "stats": stats
        }
        
    except Exception as e:
        logger.error(f"Error getting chunking stats: {e}")
        return {
            "success": False,
            "message": "Could not retrieve chunking statistics",
            "error": str(e)
        }