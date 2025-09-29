"""
Helper utility functions for ViVu Vietnam AI Service.

This module provides common utility functions used across the application.
"""

import re
import logging
from typing import List, Dict, Any, Optional, Union
import hashlib
import json
from datetime import datetime, date
import asyncio
from functools import wraps

logger = logging.getLogger(__name__)


def clean_text(text: str) -> str:
    """
    Clean and normalize text content.
    
    Args:
        text: Input text to clean
        
    Returns:
        str: Cleaned text
    """
    if not text:
        return ""
    
    # Remove extra whitespace and normalize
    text = re.sub(r'\s+', ' ', text.strip())
    
    # Remove special characters but keep Vietnamese characters
    text = re.sub(r'[^\w\s\-.,!?():;àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ]', ' ', text)
    
    # Clean up multiple spaces again
    text = re.sub(r'\s+', ' ', text.strip())
    
    return text


def normalize_destination_name(destination: str) -> str:
    """
    Normalize destination name for consistent processing.
    
    Args:
        destination: Destination name
        
    Returns:
        str: Normalized destination name
    """
    if not destination:
        return ""
    
    # Clean the text
    normalized = clean_text(destination)
    
    # Convert to title case
    normalized = normalized.title()
    
    # Handle common Vietnam destination name patterns
    replacements = {
        "Ho Chi Minh": "Ho Chi Minh City",
        "Hcmc": "Ho Chi Minh City",
        "Saigon": "Ho Chi Minh City",
        "Ha Noi": "Hanoi",
        "Ha Long": "Ha Long Bay",
        "Hoi An": "Hoi An",
        "Da Nang": "Da Nang",
        "Nha Trang": "Nha Trang",
        "Da Lat": "Da Lat",
        "Can Tho": "Can Tho",
        "Hue": "Hue",
        "Sapa": "Sapa"
    }
    
    for original, replacement in replacements.items():
        if original.lower() in normalized.lower():
            normalized = replacement
            break
    
    return normalized


def extract_cost_from_text(text: str) -> Optional[float]:
    """
    Extract cost estimate from text in Vietnamese Dong.
    
    Args:
        text: Text containing cost information
        
    Returns:
        Optional[float]: Extracted cost in VND
    """
    if not text:
        return None
    
    # Patterns for Vietnamese Dong
    patterns = [
        r'(\d{1,3}(?:[,\.]\d{3})*)\s*(?:vnd|vnđ|đ|dong)',
        r'(\d{1,3}(?:[,\.]\d{3})*)\s*thousand',
        r'(\d{1,3}(?:[,\.]\d{3})*)\s*k',
        r'(\d{1,3}(?:[,\.]\d{3})*)\s*million',
        r'(\d{1,3}(?:[,\.]\d{3})*)\s*m'
    ]
    
    text_lower = text.lower()
    
    for pattern in patterns:
        match = re.search(pattern, text_lower)
        if match:
            amount_str = match.group(1).replace(',', '').replace('.', '')
            try:
                amount = float(amount_str)
                
                # Apply multipliers
                if 'thousand' in pattern or 'k' in pattern:
                    amount *= 1000
                elif 'million' in pattern or 'm' in pattern:
                    amount *= 1000000
                
                return amount
            except ValueError:
                continue
    
    return None


def format_duration(duration_str: str) -> str:
    """
    Format duration string consistently.
    
    Args:
        duration_str: Duration string
        
    Returns:
        str: Formatted duration
    """
    if not duration_str:
        return "2 hours"
    
    duration_lower = duration_str.lower().strip()
    
    # Common duration patterns
    patterns = {
        r'(\d+)\s*h': r'\1 hours',
        r'(\d+)\s*hour': r'\1 hours',
        r'(\d+)\s*hr': r'\1 hours',
        r'(\d+)\s*min': r'\1 minutes',
        r'(\d+)\s*minute': r'\1 minutes',
        r'half\s*day': 'half day',
        r'full\s*day': 'full day',
        r'whole\s*day': 'full day'
    }
    
    for pattern, replacement in patterns.items():
        duration_lower = re.sub(pattern, replacement, duration_lower)
    
    return duration_lower


def categorize_activity(activity_name: str, description: str = "") -> str:
    """
    Categorize activity based on name and description.
    
    Args:
        activity_name: Name of the activity
        description: Activity description
        
    Returns:
        str: Activity category
    """
    combined_text = f"{activity_name} {description}".lower()
    
    # Category keywords
    categories = {
        'food': ['restaurant', 'eat', 'food', 'cuisine', 'meal', 'breakfast', 'lunch', 'dinner', 'coffee', 'street food', 'cooking'],
        'culture': ['temple', 'pagoda', 'culture', 'traditional', 'heritage', 'festival', 'ceremony', 'art', 'museum'],
        'history': ['museum', 'historical', 'history', 'war', 'colonial', 'ancient', 'monument', 'memorial'],
        'nature': ['park', 'nature', 'garden', 'mountain', 'forest', 'river', 'lake', 'waterfall', 'beach', 'island'],
        'adventure': ['trekking', 'hiking', 'climbing', 'adventure', 'sport', 'diving', 'snorkeling', 'kayaking'],
        'shopping': ['market', 'shopping', 'buy', 'souvenir', 'handicraft', 'mall', 'store'],
        'entertainment': ['show', 'performance', 'theater', 'music', 'dance', 'entertainment', 'nightlife'],
        'transportation': ['bus', 'train', 'taxi', 'transport', 'travel', 'journey', 'drive'],
        'accommodation': ['hotel', 'resort', 'homestay', 'accommodation', 'stay', 'check-in', 'check-out']
    }
    
    # Count category matches
    category_scores = {}
    for category, keywords in categories.items():
        score = sum(1 for keyword in keywords if keyword in combined_text)
        if score > 0:
            category_scores[category] = score
    
    # Return category with highest score, default to 'sightseeing'
    if category_scores:
        return max(category_scores, key=category_scores.get)
    
    return 'sightseeing'


def parse_coordinates(coord_str: str) -> Optional[Dict[str, float]]:
    """
    Parse coordinate string into lat/lng dictionary.
    
    Args:
        coord_str: Coordinate string in various formats
        
    Returns:
        Optional[Dict]: Coordinates as {"lat": float, "lng": float}
    """
    if not coord_str:
        return None
    
    # Patterns for different coordinate formats
    patterns = [
        r'(\d+\.?\d*)\s*,\s*(\d+\.?\d*)',  # "10.8231, 106.6297"
        r'lat:\s*(\d+\.?\d*)\s*,?\s*lng:\s*(\d+\.?\d*)',  # "lat: 10.8231, lng: 106.6297"
        r'(\d+\.?\d*)°?\s*N,?\s*(\d+\.?\d*)°?\s*E'  # "10.8231°N, 106.6297°E"
    ]
    
    for pattern in patterns:
        match = re.search(pattern, coord_str)
        if match:
            try:
                lat = float(match.group(1))
                lng = float(match.group(2))
                
                # Validate coordinate ranges for Vietnam
                if 8.0 <= lat <= 24.0 and 102.0 <= lng <= 110.0:
                    return {"lat": lat, "lng": lng}
            except ValueError:
                continue
    
    return None


def generate_hash(data: Union[str, Dict, List]) -> str:
    """
    Generate hash for data for caching or deduplication.
    
    Args:
        data: Data to hash
        
    Returns:
        str: MD5 hash
    """
    if isinstance(data, (dict, list)):
        data_str = json.dumps(data, sort_keys=True)
    else:
        data_str = str(data)
    
    return hashlib.md5(data_str.encode('utf-8')).hexdigest()


def format_vietnamese_currency(amount: float) -> str:
    """
    Format amount as Vietnamese currency.
    
    Args:
        amount: Amount in VND
        
    Returns:
        str: Formatted currency string
    """
    if amount >= 1000000:
        return f"{amount / 1000000:.1f} million VND"
    elif amount >= 1000:
        return f"{amount / 1000:.0f},000 VND"
    else:
        return f"{amount:.0f} VND"


def validate_vietnamese_phone(phone: str) -> bool:
    """
    Validate Vietnamese phone number format.
    
    Args:
        phone: Phone number string
        
    Returns:
        bool: True if valid Vietnamese phone number
    """
    if not phone:
        return False
    
    # Remove spaces and special characters
    clean_phone = re.sub(r'[^\d+]', '', phone)
    
    # Vietnamese phone patterns
    patterns = [
        r'^\+84[0-9]{9,10}$',  # International format
        r'^84[0-9]{9,10}$',    # Without plus
        r'^0[0-9]{9,10}$'      # Local format
    ]
    
    return any(re.match(pattern, clean_phone) for pattern in patterns)


def async_retry(max_attempts: int = 3, delay: float = 1.0, backoff: float = 2.0):
    """
    Decorator for async functions with retry logic.
    
    Args:
        max_attempts: Maximum number of retry attempts
        delay: Initial delay between attempts
        backoff: Delay multiplier for exponential backoff
    """
    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            last_exception = None
            
            for attempt in range(max_attempts):
                try:
                    return await func(*args, **kwargs)
                except Exception as e:
                    last_exception = e
                    
                    if attempt == max_attempts - 1:
                        break
                    
                    wait_time = delay * (backoff ** attempt)
                    logger.warning(
                        f"Attempt {attempt + 1} failed for {func.__name__}: {e}. "
                        f"Retrying in {wait_time:.2f} seconds..."
                    )
                    await asyncio.sleep(wait_time)
            
            logger.error(f"All {max_attempts} attempts failed for {func.__name__}")
            raise last_exception
        
        return wrapper
    return decorator


def serialize_datetime(obj: Any) -> Any:
    """
    JSON serializer for datetime objects.
    
    Args:
        obj: Object to serialize
        
    Returns:
        Any: Serialized object
    """
    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")


def create_slug(text: str) -> str:
    """
    Create URL-friendly slug from text.
    
    Args:
        text: Input text
        
    Returns:
        str: URL-friendly slug
    """
    if not text:
        return ""
    
    # Convert to lowercase and clean
    slug = clean_text(text).lower()
    
    # Replace spaces with hyphens
    slug = re.sub(r'\s+', '-', slug)
    
    # Remove non-alphanumeric characters except hyphens
    slug = re.sub(r'[^a-z0-9\-]', '', slug)
    
    # Remove multiple consecutive hyphens
    slug = re.sub(r'-+', '-', slug)
    
    # Remove leading/trailing hyphens
    slug = slug.strip('-')
    
    return slug


def chunk_list(lst: List[Any], chunk_size: int) -> List[List[Any]]:
    """
    Split list into chunks of specified size.
    
    Args:
        lst: Input list
        chunk_size: Size of each chunk
        
    Returns:
        List[List]: List of chunks
    """
    return [lst[i:i + chunk_size] for i in range(0, len(lst), chunk_size)]


def calculate_distance(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    """
    Calculate distance between two coordinates using Haversine formula.
    
    Args:
        lat1, lng1: First coordinate
        lat2, lng2: Second coordinate
        
    Returns:
        float: Distance in kilometers
    """
    import math
    
    # Convert to radians
    lat1, lng1, lat2, lng2 = map(math.radians, [lat1, lng1, lat2, lng2])
    
    # Haversine formula
    dlat = lat2 - lat1
    dlng = lng2 - lng1
    a = math.sin(dlat/2)**2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlng/2)**2
    c = 2 * math.asin(math.sqrt(a))
    
    # Earth's radius in kilometers
    r = 6371
    
    return c * r


# Export all utility functions
__all__ = [
    "clean_text",
    "normalize_destination_name",
    "extract_cost_from_text",
    "format_duration",
    "categorize_activity",
    "parse_coordinates",
    "generate_hash",
    "format_vietnamese_currency",
    "validate_vietnamese_phone",
    "async_retry",
    "serialize_datetime",
    "create_slug",
    "chunk_list",
    "calculate_distance",
]