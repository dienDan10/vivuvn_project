"""
Google Gemini AI service for ViVu Vietnam AI Service.

This module handles interactions with Google Gemini API for generating
travel itineraries and content.
"""

import logging
from typing import Dict, List, Optional, Any
import asyncio
from datetime import datetime

import google.generativeai as genai
from google.generativeai.types import HarmCategory, HarmBlockThreshold

from app.core.config import settings
from app.core.exceptions import GeminiAPIError, AIServiceError
from app.api.schemas import TravelRequest, TravelResponse

logger = logging.getLogger(__name__)


class GeminiAIService:
    """Google Gemini AI service for travel content generation."""
    
    def __init__(self):
        """Initialize Gemini AI service with configuration."""
        self.api_key = settings.GEMINI_API_KEY
        self.model_name = "gemini-pro"
        self.temperature = settings.TEMPERATURE
        self.max_tokens = settings.MAX_TOKENS
        self._model = None
        self._initialize_client()
    
    def _initialize_client(self):
        """Initialize Gemini API client."""
        try:
            genai.configure(api_key=self.api_key)
            
            # Configure model with safety settings
            self._model = genai.GenerativeModel(
                model_name=self.model_name,
                generation_config=genai.types.GenerationConfig(
                    temperature=self.temperature,
                    max_output_tokens=self.max_tokens,
                    top_p=0.8,
                    top_k=40
                ),
                safety_settings={
                    HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
                    HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
                    HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
                    HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
                }
            )
            
            logger.info("Gemini AI service initialized successfully")
            
        except Exception as e:
            logger.error(f"Failed to initialize Gemini AI service: {e}")
            raise GeminiAPIError(f"Failed to initialize Gemini AI: {str(e)}")
    
    async def generate_itinerary(
        self,
        travel_request: TravelRequest,
        context_data: Optional[List[Dict[str, Any]]] = None
    ) -> str:
        """
        Generate travel itinerary using Gemini AI.
        
        Args:
            travel_request: Travel request parameters
            context_data: Relevant travel data from vector search
            
        Returns:
            str: Generated itinerary content
        """
        try:
            prompt = self._build_itinerary_prompt(travel_request, context_data)
            
            logger.info(f"Generating itinerary for {travel_request.destination}")
            
            # Generate content with retry logic
            response = await self._generate_with_retry(prompt)
            
            if not response or not response.text:
                raise GeminiAPIError("Empty response from Gemini API")
            
            logger.info("Itinerary generated successfully")
            return response.text
            
        except Exception as e:
            logger.error(f"Failed to generate itinerary: {e}")
            raise GeminiAPIError(f"Itinerary generation failed: {str(e)}")
    
    def _build_itinerary_prompt(
        self,
        travel_request: TravelRequest,
        context_data: Optional[List[Dict[str, Any]]] = None
    ) -> str:
        """
        Build comprehensive prompt for itinerary generation.
        
        Args:
            travel_request: Travel request parameters
            context_data: Relevant travel data from vector search
            
        Returns:
            str: Formatted prompt for Gemini
        """
        # Base information
        duration = travel_request.duration_days
        preferences_str = ", ".join(travel_request.preferences) if travel_request.preferences else "general sightseeing"
        
        # Build context from vector search results
        context_section = ""
        if context_data:
            context_section = "\n## Available Information:\n"
            for item in context_data[:10]:  # Limit to top 10 results
                content = item.get("content", "")
                context_section += f"- {content}\n"
        
        # Special requirements
        special_reqs = ""
        if travel_request.special_requirements:
            special_reqs = f"\n## Special Requirements:\n{travel_request.special_requirements}\n"
        
        prompt = f"""
You are an expert Vietnam travel planner with deep knowledge of Vietnamese culture, destinations, and travel logistics. Create a detailed {duration}-day itinerary for {travel_request.destination}, Vietnam.

## Trip Details:
- Destination: {travel_request.destination}
- Duration: {duration} days ({travel_request.start_date} to {travel_request.end_date})
- Group Size: {travel_request.group_size} people
- Preferences: {preferences_str}
- Budget Range: {travel_request.budget_range or 'moderate'}
- Travel Style: {travel_request.travel_style or 'balanced'}
{special_reqs}
{context_section}

## Instructions:
1. Create a day-by-day itinerary with specific activities
2. Include time schedules (use 24-hour format like "09:00")
3. Provide realistic cost estimates in Vietnamese Dong (VND)
4. Include specific addresses and locations
5. Add cultural insights and practical tips
6. Consider Vietnamese culture, customs, and local etiquette
7. Suggest authentic local experiences and food
8. Include transportation recommendations between activities
9. Account for weather and seasonal considerations
10. Provide backup indoor activities for rainy weather

## Output Format:
Please structure your response as a detailed itinerary with:
- Day number and date
- Morning, afternoon, and evening activities
- Specific times for each activity
- Detailed descriptions of activities
- Exact locations with addresses
- Duration estimates
- Cost estimates in VND
- Category tags (food, culture, history, nature, etc.)
- Daily notes and recommendations

## Important Guidelines:
- Focus specifically on Vietnam and Vietnamese culture
- Use accurate Vietnamese place names and proper spellings
- Include traditional Vietnamese cuisine recommendations
- Suggest respectful cultural practices
- Provide realistic travel times between locations
- Consider local business hours and closing days
- Include both popular attractions and hidden gems
- Suggest appropriate dress codes for temples/religious sites
- Provide Vietnamese phrases that might be helpful
- Include emergency contact information and practical tips

Begin with Day 1 and create a comprehensive itinerary that showcases the best of {travel_request.destination} while respecting Vietnamese culture and traditions.
"""
        
        return prompt.strip()
    
    async def _generate_with_retry(self, prompt: str, max_retries: int = 3) -> Any:
        """
        Generate content with retry logic.
        
        Args:
            prompt: Input prompt for generation
            max_retries: Maximum number of retry attempts
            
        Returns:
            Generated response from Gemini
        """
        last_error = None
        
        for attempt in range(max_retries):
            try:
                # Add delay between retries
                if attempt > 0:
                    await asyncio.sleep(2 ** attempt)  # Exponential backoff
                
                # Generate content asynchronously
                response = await asyncio.get_event_loop().run_in_executor(
                    None, self._model.generate_content, prompt
                )
                
                # Check for safety blocks
                if hasattr(response, 'prompt_feedback') and response.prompt_feedback.block_reason:
                    raise GeminiAPIError(f"Content blocked: {response.prompt_feedback.block_reason}")
                
                # Check for finish reason
                if hasattr(response, 'candidates') and response.candidates:
                    candidate = response.candidates[0]
                    if hasattr(candidate, 'finish_reason') and candidate.finish_reason != 1:  # STOP
                        logger.warning(f"Generation finished with reason: {candidate.finish_reason}")
                
                return response
                
            except Exception as e:
                last_error = e
                logger.warning(f"Gemini API attempt {attempt + 1} failed: {e}")
                
                if attempt == max_retries - 1:
                    break
        
        raise GeminiAPIError(f"Failed after {max_retries} attempts: {str(last_error)}")
    
    async def enhance_activity_description(self, activity_name: str, location: str) -> str:
        """
        Enhance activity description with cultural context.
        
        Args:
            activity_name: Name of the activity
            location: Location in Vietnam
            
        Returns:
            str: Enhanced description
        """
        try:
            prompt = f"""
Provide a detailed and culturally rich description for this Vietnam travel activity:

Activity: {activity_name}
Location: {location}, Vietnam

Please include:
- Cultural significance and historical context
- What visitors can expect to see and experience
- Best times to visit
- Cultural etiquette and respectful behavior
- Practical tips for visitors
- Unique aspects that make this special in Vietnamese culture

Keep the description informative yet engaging, highlighting the authentic Vietnamese experience.
"""
            
            response = await self._generate_with_retry(prompt)
            return response.text if response and response.text else ""
            
        except Exception as e:
            logger.error(f"Failed to enhance activity description: {e}")
            return f"Experience {activity_name} in {location}, a wonderful destination in Vietnam."
    
    async def generate_travel_recommendations(
        self,
        destination: str,
        preferences: List[str]
    ) -> List[str]:
        """
        Generate general travel recommendations.
        
        Args:
            destination: Vietnam destination
            preferences: User preferences
            
        Returns:
            List[str]: Travel recommendations
        """
        try:
            preferences_str = ", ".join(preferences) if preferences else "general travel"
            
            prompt = f"""
Generate 5-7 practical travel recommendations for visiting {destination}, Vietnam.

Focus on:
- {preferences_str}
- Local customs and etiquette
- Practical travel tips
- Hidden gems and local secrets
- Food and dining recommendations
- Transportation advice
- Cultural insights

Provide specific, actionable advice that would be valuable for travelers to Vietnam.
Format as a simple list of recommendations.
"""
            
            response = await self._generate_with_retry(prompt)
            
            if response and response.text:
                # Parse recommendations from response
                recommendations = []
                for line in response.text.split('\n'):
                    line = line.strip()
                    if line and (line.startswith('-') or line.startswith('•') or line[0].isdigit()):
                        # Clean up formatting
                        clean_line = line.lstrip('-•0123456789. ').strip()
                        if clean_line:
                            recommendations.append(clean_line)
                
                return recommendations[:7]  # Limit to 7 recommendations
            
            return []
            
        except Exception as e:
            logger.error(f"Failed to generate recommendations: {e}")
            return [
                f"Explore the local culture and cuisine in {destination}",
                "Learn basic Vietnamese phrases for better communication",
                "Respect local customs and dress codes at religious sites",
                "Try street food from reputable vendors",
                "Carry cash as many places don't accept cards"
            ]
    
    async def validate_destination(self, destination: str) -> bool:
        """
        Validate if destination is a real place in Vietnam.
        
        Args:
            destination: Destination name to validate
            
        Returns:
            bool: True if valid Vietnam destination
        """
        try:
            prompt = f"""
Is "{destination}" a real place in Vietnam that tourists can visit?

Respond with only "YES" if it's a legitimate tourist destination in Vietnam, or "NO" if it's not.
Consider major cities, provinces, districts, tourist areas, and well-known destinations.
"""
            
            response = await self._generate_with_retry(prompt)
            
            if response and response.text:
                return response.text.strip().upper() == "YES"
            
            return False
            
        except Exception as e:
            logger.error(f"Failed to validate destination: {e}")
            # If validation fails, assume it's valid to avoid blocking legitimate requests
            return True
    
    async def health_check(self) -> bool:
        """
        Check if Gemini AI service is healthy.
        
        Returns:
            bool: True if service is healthy
        """
        try:
            test_prompt = "Say 'OK' if you can understand this message."
            response = await self._generate_with_retry(test_prompt)
            
            return bool(response and response.text and "OK" in response.text.upper())
            
        except Exception as e:
            logger.error(f"Gemini AI health check failed: {e}")
            return False


# Global service instance
_gemini_service = None


def get_gemini_service() -> GeminiAIService:
    """Get global Gemini AI service instance."""
    global _gemini_service
    if _gemini_service is None:
        _gemini_service = GeminiAIService()
    return _gemini_service


# Export service and utilities
__all__ = [
    "GeminiAIService",
    "get_gemini_service",
]