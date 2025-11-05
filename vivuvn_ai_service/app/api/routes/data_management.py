"""
Data management API routes for ViVu Vietnam AI Service.

This module provides endpoints for managing travel data in Pinecone vector database.
"""

import structlog
from fastapi import APIRouter, UploadFile, File, Form
from fastapi.responses import JSONResponse

from app.core.config import settings
from app.utils.data_loader import get_data_loader
from app.api.schemas import (
    DataInsertRequest,
    DataInsertResponse,
    DataDeleteRequest,
    DataDeleteResponse,
    DataBatchUploadResponse
)

logger = structlog.get_logger(__name__)

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
    logger.info(f"Inserting {request.item_type}", item_type=request.item_type)

    data_loader = get_data_loader()

    # Only support 'place' type in optimized version
    if request.item_type != "place":
        raise ValueError("Only 'place' item type is supported in optimized version")

    success = await data_loader.insert_single_item(
        item_type=request.item_type,
        item_data=request.data
    )

    if not success:
        raise ValueError(f"Failed to insert {request.item_type}")

    logger.info(f"Successfully inserted {request.item_type}", item_id=request.data.get("googlePlaceId"))

    return DataInsertResponse(
        success=True,
        message=f"Successfully inserted {request.item_type}",
        item_id=request.data.get("googlePlaceId") or request.data.get("id"),
        item_type=request.item_type
    )


@router.delete("/delete", response_model=DataDeleteResponse)
async def delete_data_item(request: DataDeleteRequest):
    """
    Delete a data item from Pinecone by ID.

    Args:
        request: Item ID to delete

    Returns:
        DataDeleteResponse: Success status
    """
    logger.info(f"Deleting item {request.item_id}", item_id=request.item_id)

    data_loader = get_data_loader()
    success = await data_loader.delete_item(request.item_id)

    if not success:
        raise ValueError(f"Item {request.item_id} not found or could not be deleted")

    logger.info(f"Successfully deleted item {request.item_id}", item_id=request.item_id)

    return DataDeleteResponse(
        success=True,
        message=f"Successfully deleted item {request.item_id}",
        item_id=request.item_id
    )


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
    logger.info(f"Starting batch upload", data_type=data_type, filename=file.filename)

    # Validate data type - only support 'places' in optimized version
    if data_type != "places":
        raise ValueError("Only 'places' data type is supported in optimized version")

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

        logger.info(
            f"Successfully uploaded {loaded_count} {data_type}",
            loaded_count=loaded_count,
            data_type=data_type,
            filename=file.filename
        )

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


@router.post("/load-location-data")
async def load_location_data_file():
    """
    Load data from the local location_data.json file.
    This is a one-time operation to populate the database.

    Returns:
        dict: Load operation results
    """
    logger.info("Loading location data from file")

    data_loader = get_data_loader()

    # Path to the location data file
    file_path = "d:/FU/SEP490/vivuvn_project/vivuvn_api/vivuvn_api/Data/location_data.json"

    # Check if file exists
    import os
    if not os.path.exists(file_path):
        raise FileNotFoundError("location_data.json file not found")

    # Load places from the location data file
    loaded_count = await data_loader.load_places_from_json(file_path)

    logger.info(
        f"Successfully loaded {loaded_count} places from location_data.json",
        loaded_count=loaded_count
    )

    return {
        "success": True,
        "message": f"Successfully loaded {loaded_count} places from location_data.json",
        "loaded_count": loaded_count,
        "data_type": "places",
        "source_file": "location_data.json"
    }


@router.post("/initialize-index")
async def initialize_vector_index():
    """
    Initialize or verify the Pinecone vector index.

    Returns:
        dict: Index initialization status
    """
    logger.info("Initializing vector index")

    data_loader = get_data_loader()
    await data_loader.create_vector_index()

    logger.info("Vector index initialized successfully")

    return {
        "success": True,
        "message": "Vector index initialized successfully"
    }


@router.get("/stats")
async def get_data_stats():
    """
    Get statistics about data in Pinecone.
    
    Returns:
        dict: Data statistics
    """
    try:
        from app.services.pinecone_service import get_pinecone_service
        pinecone_service = get_pinecone_service()

        # Get index stats (if available)
        stats = await pinecone_service.get_index_stats()
        
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


@router.get("/test-query")
async def test_pinecone_query():
    """
    Diagnostic endpoint to test Pinecone query functionality.
    Returns detailed information about index and query execution.

    This helps diagnose issues with vector search and data retrieval.

    Returns:
        dict: Diagnostic information including query results and index stats
    """
    try:
        from app.services.pinecone_service import get_pinecone_service
        from app.services.embedding_service import get_embedding_service

        pinecone_service = get_pinecone_service()
        embedding_service = get_embedding_service()

        # Get index stats (now returns JSON-serializable dict)
        stats = await pinecone_service.get_index_stats()

        # Try a test query
        test_query = "Hà Nội travel destinations Vietnam"
        # Use RETRIEVAL_QUERY task type for search queries
        test_embedding = await embedding_service._generate_embedding(
            test_query,
            task_type=settings.EMBEDDING_TASK_TYPE_QUERY
        )

        # Query configured namespace (travel_location)
        results = await pinecone_service.search(
            vector=test_embedding,
            top_k=5,
            namespace=None,  # Uses PINECONE_DEFAULT_NAMESPACE from settings
            include_metadata=True
        )

        return JSONResponse(content={
            "success": True,
            "message": "Query test completed",
            "test_query": test_query,
            "index_stats": stats,
            "results_count": len(results),
            "sample_results": results[:3] if results else [],
            "diagnosis": {
                "vectors_in_index": stats.get("total_vectors", 0),
                "namespace_used": settings.PINECONE_DEFAULT_NAMESPACE,
                "query_successful": len(results) > 0,
                "need_reload_data": len(results) == 0 and stats.get("total_vectors", 0) == 0,
                "message": "✅ Query successful!" if len(results) > 0 else "⚠️ No results found - may need to reload data"
            }
        })

    except Exception as e:
        logger.error(f"Test query failed: {e}", exc_info=True)
        return JSONResponse(content={
            "success": False,
            "error": str(e),
            "error_type": type(e).__name__,
            "diagnosis": {
                "message": f"❌ Query failed: {str(e)}"
            }
        })