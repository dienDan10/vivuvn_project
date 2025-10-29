"""Prompts module for ViVu Vietnam AI Service."""

from app.prompts.travel_prompts import get_system_prompt_for_request, create_user_prompt

__all__ = ["get_system_prompt_for_request", "create_user_prompt"]
