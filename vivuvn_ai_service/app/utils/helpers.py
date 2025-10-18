"""
Helper utility functions for ViVu Vietnam AI Service.

This module provides common utility functions used across the application.
"""

from typing import List, Any


def normalize_province_name(province: str) -> str:
    """
    Normalize Vietnamese province name by removing common prefixes.

    This function strips administrative prefixes like "Thành phố" (City),
    "Tỉnh" (Province), "Huyện" (District) to ensure consistent province
    matching in database queries.

    Examples:
        - "Thành phố Hà Nội" -> "Hà Nội"
        - "Thành phố Đà Nẵng" -> "Đà Nẵng"
        - "Tỉnh Lâm Đồng" -> "Lâm Đồng"
        - "Hà Nội" -> "Hà Nội" (unchanged)

    Args:
        province: Province name with or without prefix

    Returns:
        str: Normalized province name without administrative prefix
    """
    if not province:
        return ""

    # Strip and clean the input
    normalized = province.strip()

    # Common Vietnamese administrative prefixes (case-insensitive)
    prefixes = [
        "Thành phố",  # City
        "Tỉnh",       # Province
        "Huyện",      # District
    ]

    # Remove prefix if present (case-insensitive matching)
    for prefix in prefixes:
        # Check if normalized starts with prefix (case-insensitive)
        if normalized.lower().startswith(prefix.lower()):
            # Remove prefix and any following whitespace
            normalized = normalized[len(prefix):].strip()
            break

    return normalized


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


# Export all utility functions
__all__ = [
    "normalize_province_name",
    "chunk_list",
]
