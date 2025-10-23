"""
Models package for the travel AI service.

This package contains Pydantic models used for structured data validation
throughout the application.
"""

from .travel_models import Activity, DayItinerary, TravelItinerary

__all__ = ["Activity", "DayItinerary", "TravelItinerary"]