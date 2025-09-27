"""
LangGraph travel agent for ViVu Vietnam AI Service.

This module implements a RAG-based travel planning agent using LangGraph
to orchestrate the retrieval and generation process for creating Vietnam travel itineraries.
"""

import logging
from typing import Dict, List, Any, Optional, TypedDict
import json
import asyncio
from datetime import datetime, timedelta

from langgraph.graph import StateGraph, END
from langgraph.prebuilt import create_react_agent
from langchain.schema import BaseMessage, HumanMessage, AIMessage, SystemMessage
from langchain.tools import Tool
from langchain_google_genai import ChatGoogleGenerativeAI

from app.core.config import settings
from app.core.exceptions import TravelPlanningError, ItineraryGenerationError
from app.api.schemas import TravelRequest, TravelResponse, DayItinerary, Activity
from app.services.ai_service import get_gemini_service
from app.services.vector_service import get_vector_service

logger = logging.getLogger(__name__)


class AgentState(TypedDict):
    """State for the travel planning agent."""
    travel_request: TravelRequest
    context_data: List[Dict[str, Any]]
    destination_info: Dict[str, Any]
    activity_suggestions: List[Dict[str, Any]]
    generated_content: str
    parsed_itinerary: Dict[str, Any]
    recommendations: List[str]
    error: Optional[str]
    messages: List[BaseMessage]


class TravelPlanningAgent:
    """LangGraph-based travel planning agent with RAG pattern."""
    
    def __init__(self):
        """Initialize the travel planning agent."""
        self.gemini_service = get_gemini_service()
        self.vector_service = get_vector_service()
        self.llm = ChatGoogleGenerativeAI(
            model="gemini-pro",
            google_api_key=settings.GEMINI_API_KEY,
            temperature=settings.TEMPERATURE,
            max_output_tokens=settings.MAX_TOKENS
        )
        self.graph = self._build_agent_graph()
    
    def _build_agent_graph(self) -> StateGraph:
        """Build the LangGraph workflow for travel planning."""
        
        # Create tools for the agent
        tools = self._create_agent_tools()
        
        # Create the agent with tools
        agent = create_react_agent(self.llm, tools)
        
        # Define the workflow graph
        workflow = StateGraph(AgentState)
        
        # Add nodes
        workflow.add_node("gather_context", self._gather_context_node)
        workflow.add_node("retrieve_destinations", self._retrieve_destinations_node)
        workflow.add_node("retrieve_activities", self._retrieve_activities_node)
        workflow.add_node("generate_itinerary", self._generate_itinerary_node)
        workflow.add_node("parse_response", self._parse_response_node)
        workflow.add_node("generate_recommendations", self._generate_recommendations_node)
        workflow.add_node("finalize_response", self._finalize_response_node)
        
        # Define the flow
        workflow.set_entry_point("gather_context")
        workflow.add_edge("gather_context", "retrieve_destinations")
        workflow.add_edge("retrieve_destinations", "retrieve_activities")
        workflow.add_edge("retrieve_activities", "generate_itinerary")
        workflow.add_edge("generate_itinerary", "parse_response")
        workflow.add_edge("parse_response", "generate_recommendations")
        workflow.add_edge("generate_recommendations", "finalize_response")
        workflow.add_edge("finalize_response", END)
        
        return workflow.compile()
    
    def _create_agent_tools(self) -> List[Tool]:
        """Create tools for the LangGraph agent."""
        
        def search_destinations(query: str) -> str:
            """Search for destinations in Vietnam."""
            try:
                # This would be called synchronously within the agent
                results = asyncio.create_task(
                    self.vector_service.search_destinations(query)
                )
                destinations = asyncio.run(results)
                return json.dumps(destinations, indent=2)
            except Exception as e:
                return f"Error searching destinations: {str(e)}"
        
        def search_activities(query: str, destination_id: str = None) -> str:
            """Search for activities and attractions."""
            try:
                results = asyncio.create_task(
                    self.vector_service.search_activities(query, destination_id)
                )
                activities = asyncio.run(results)
                return json.dumps(activities, indent=2)
            except Exception as e:
                return f"Error searching activities: {str(e)}"
        
        def get_weather_info(destination: str, month: int) -> str:
            """Get weather information for destination."""
            # Simplified weather information
            weather_data = {
                1: "Cool and dry, 15-25°C, ideal for sightseeing",
                2: "Cool and dry, 16-26°C, great weather",
                3: "Warm, 20-30°C, occasional light rain",
                4: "Warm and humid, 25-32°C, more frequent rain",
                5: "Hot and humid, 26-35°C, rainy season begins",
                6: "Hot and wet, 26-33°C, heavy rain possible",
                7: "Hot and wet, 26-33°C, peak rainy season",
                8: "Hot and wet, 26-33°C, frequent storms",
                9: "Warm and wet, 25-32°C, rain continues",
                10: "Warm, 23-30°C, rain decreases",
                11: "Pleasant, 20-28°C, dry season returns",
                12: "Cool and dry, 17-26°C, excellent weather"
            }
            return weather_data.get(month, "Weather information not available")
        
        return [
            Tool(
                name="search_destinations",
                description="Search for destinations in Vietnam",
                func=search_destinations
            ),
            Tool(
                name="search_activities", 
                description="Search for activities and attractions",
                func=search_activities
            ),
            Tool(
                name="get_weather_info",
                description="Get weather information for a destination and month",
                func=get_weather_info
            ),
        ]
    
    async def _gather_context_node(self, state: AgentState) -> AgentState:
        """Gather initial context about the travel request."""
        try:
            travel_request = state["travel_request"]
            
            # Build context query
            context_query = f"{travel_request.destination} Vietnam travel"
            if travel_request.preferences:
                context_query += f" {' '.join(travel_request.preferences)}"
            
            # Get contextual information
            context_data = await self.vector_service.get_contextual_information(
                destination=travel_request.destination,
                preferences=travel_request.preferences,
                limit=15
            )
            
            state["context_data"] = context_data
            state["messages"] = [
                SystemMessage(content="You are a Vietnam travel expert. Plan comprehensive itineraries with cultural insights."),
                HumanMessage(content=f"Planning trip to {travel_request.destination} for {(travel_request.end_date - travel_request.start_date).days + 1} days")
            ]
            
            logger.info(f"Gathered {len(context_data)} contextual items")
            return state
            
        except Exception as e:
            logger.error(f"Context gathering failed: {e}")
            state["error"] = str(e)
            return state
    
    async def _retrieve_destinations_node(self, state: AgentState) -> AgentState:
        """Retrieve destination information."""
        try:
            travel_request = state["travel_request"]
            
            # Search for destination information
            destinations = await self.vector_service.search_destinations(
                query_text=travel_request.destination,
                limit=3
            )
            
            # Find the best matching destination
            destination_info = {}
            if destinations:
                best_match = destinations[0]
                destination_info = {
                    "name": best_match.get("name", travel_request.destination),
                    "region": best_match.get("region", "Vietnam"),
                    "description": best_match.get("description", ""),
                    "coordinates": best_match.get("coordinates"),
                    "similarity_score": best_match.get("similarity_score", 0.0)
                }
            
            state["destination_info"] = destination_info
            logger.info(f"Retrieved destination info for {travel_request.destination}")
            return state
            
        except Exception as e:
            logger.error(f"Destination retrieval failed: {e}")
            state["error"] = str(e)
            return state
    
    async def _retrieve_activities_node(self, state: AgentState) -> AgentState:
        """Retrieve relevant activities and attractions."""
        try:
            travel_request = state["travel_request"]
            destination_info = state.get("destination_info", {})
            
            # Build activity search query
            activity_query = f"{travel_request.destination} activities attractions"
            if travel_request.preferences:
                activity_query += f" {' '.join(travel_request.preferences)}"
            
            # Search for activities
            activities = await self.vector_service.search_activities(
                query_text=activity_query,
                destination_id=destination_info.get("id"),
                preferences=travel_request.preferences,
                limit=20
            )
            
            state["activity_suggestions"] = activities
            logger.info(f"Retrieved {len(activities)} activity suggestions")
            return state
            
        except Exception as e:
            logger.error(f"Activity retrieval failed: {e}")
            state["error"] = str(e)
            return state
    
    async def _generate_itinerary_node(self, state: AgentState) -> AgentState:
        """Generate the travel itinerary using Gemini AI."""
        try:
            travel_request = state["travel_request"]
            context_data = state.get("context_data", [])
            
            # Generate itinerary content
            generated_content = await self.gemini_service.generate_itinerary(
                travel_request=travel_request,
                context_data=context_data
            )
            
            state["generated_content"] = generated_content
            state["messages"].append(
                AIMessage(content=f"Generated itinerary for {travel_request.destination}")
            )
            
            logger.info("Itinerary content generated successfully")
            return state
            
        except Exception as e:
            logger.error(f"Itinerary generation failed: {e}")
            state["error"] = str(e)
            return state
    
    async def _parse_response_node(self, state: AgentState) -> AgentState:
        """Parse the generated itinerary into structured format."""
        try:
            generated_content = state.get("generated_content", "")
            travel_request = state["travel_request"]
            
            if not generated_content:
                raise ValueError("No generated content to parse")
            
            # Parse the itinerary content
            parsed_itinerary = self._parse_itinerary_content(
                generated_content, travel_request
            )
            
            state["parsed_itinerary"] = parsed_itinerary
            logger.info("Itinerary parsed successfully")
            return state
            
        except Exception as e:
            logger.error(f"Itinerary parsing failed: {e}")
            state["error"] = str(e)
            return state
    
    async def _generate_recommendations_node(self, state: AgentState) -> AgentState:
        """Generate travel recommendations."""
        try:
            travel_request = state["travel_request"]
            
            # Generate recommendations
            recommendations = await self.gemini_service.generate_travel_recommendations(
                destination=travel_request.destination,
                preferences=travel_request.preferences
            )
            
            state["recommendations"] = recommendations
            logger.info(f"Generated {len(recommendations)} recommendations")
            return state
            
        except Exception as e:
            logger.error(f"Recommendation generation failed: {e}")
            state["recommendations"] = []
            return state
    
    async def _finalize_response_node(self, state: AgentState) -> AgentState:
        """Finalize the response with all components."""
        try:
            travel_request = state["travel_request"]
            parsed_itinerary = state.get("parsed_itinerary", {})
            recommendations = state.get("recommendations", [])
            
            # Create final response structure
            final_response = {
                "destination": travel_request.destination,
                "total_days": (travel_request.end_date - travel_request.start_date).days + 1,
                "itinerary": parsed_itinerary.get("days", []),
                "total_estimated_cost": parsed_itinerary.get("total_cost"),
                "recommendations": recommendations,
                "weather_info": self._get_weather_info(travel_request),
                "generated_at": datetime.utcnow()
            }
            
            state["final_response"] = final_response
            logger.info("Response finalized successfully")
            return state
            
        except Exception as e:
            logger.error(f"Response finalization failed: {e}")
            state["error"] = str(e)
            return state
    
    def _parse_itinerary_content(
        self, 
        content: str, 
        travel_request: TravelRequest
    ) -> Dict[str, Any]:
        """
        Parse generated itinerary content into structured format.
        
        Args:
            content: Generated itinerary text
            travel_request: Original travel request
            
        Returns:
            Dict: Parsed itinerary data
        """
        try:
            lines = content.split('\n')
            days = []
            current_day = None
            total_cost = 0.0
            
            for line in lines:
                line = line.strip()
                if not line:
                    continue
                
                # Look for day headers
                if any(keyword in line.lower() for keyword in ['day ', 'ngày ']):
                    if current_day:
                        days.append(current_day)
                    
                    # Extract day number
                    day_num = len(days) + 1
                    date_str = (travel_request.start_date + 
                              timedelta(days=day_num-1)).strftime("%Y-%m-%d")
                    
                    current_day = {
                        "day": day_num,
                        "date": date_str,
                        "activities": [],
                        "estimated_cost": 0.0,
                        "notes": ""
                    }
                
                # Parse activities (look for time patterns)
                elif current_day and any(char.isdigit() for char in line[:6]):
                    activity = self._parse_activity_line(line)
                    if activity:
                        current_day["activities"].append(activity)
                        if activity.get("cost_estimate"):
                            current_day["estimated_cost"] += activity["cost_estimate"]
            
            # Add final day
            if current_day:
                days.append(current_day)
            
            # Calculate total cost
            for day in days:
                if day.get("estimated_cost"):
                    total_cost += day["estimated_cost"]
            
            return {
                "days": days,
                "total_cost": total_cost if total_cost > 0 else None
            }
            
        except Exception as e:
            logger.error(f"Failed to parse itinerary content: {e}")
            return {"days": [], "total_cost": None}
    
    def _parse_activity_line(self, line: str) -> Optional[Dict[str, Any]]:
        """Parse a single activity line."""
        try:
            # Simple parsing logic - this could be enhanced
            parts = line.split(' - ', 1)
            if len(parts) < 2:
                return None
            
            time_part = parts[0].strip()
            content_part = parts[1].strip()
            
            # Extract time
            time_match = None
            for i, char in enumerate(time_part):
                if char.isdigit() and ':' in time_part[i:i+6]:
                    time_match = time_part[i:i+5]
                    break
            
            if not time_match:
                time_match = "09:00"
            
            return {
                "time": time_match,
                "name": content_part.split('.')[0] if '.' in content_part else content_part,
                "description": content_part,
                "location": "Vietnam",
                "duration": "2 hours",
                "cost_estimate": 0.0,
                "category": "sightseeing"
            }
            
        except Exception:
            return None
    
    def _get_weather_info(self, travel_request: TravelRequest) -> str:
        """Get weather information for the travel period."""
        month = travel_request.start_date.month
        
        weather_map = {
            1: "Cool and dry season, 15-25°C, excellent for sightseeing",
            2: "Cool and dry, 16-26°C, perfect weather conditions",
            3: "Warm and pleasant, 20-30°C, occasional light showers",
            4: "Warm and humid, 25-32°C, increasing rainfall",
            5: "Hot and humid, 26-35°C, rainy season begins",
            6: "Hot and wet, 26-33°C, frequent heavy rains",
            7: "Hot and wet, 26-33°C, peak rainy season",
            8: "Hot and wet, 26-33°C, storms possible",
            9: "Warm and wet, 25-32°C, rain continues",
            10: "Warm, 23-30°C, rainfall decreases",
            11: "Pleasant, 20-28°C, dry season returns",
            12: "Cool and dry, 17-26°C, ideal travel weather"
        }
        
        return weather_map.get(month, "Weather information not available")
    
    async def plan_travel(self, travel_request: TravelRequest) -> TravelResponse:
        """
        Plan a travel itinerary using the LangGraph agent.
        
        Args:
            travel_request: Travel planning request
            
        Returns:
            TravelResponse: Complete travel itinerary
        """
        try:
            # Initialize agent state
            initial_state: AgentState = {
                "travel_request": travel_request,
                "context_data": [],
                "destination_info": {},
                "activity_suggestions": [],
                "generated_content": "",
                "parsed_itinerary": {},
                "recommendations": [],
                "error": None,
                "messages": []
            }
            
            # Run the agent workflow
            logger.info(f"Starting travel planning for {travel_request.destination}")
            final_state = await self.graph.ainvoke(initial_state)
            
            # Check for errors
            if final_state.get("error"):
                raise ItineraryGenerationError(
                    f"Travel planning failed: {final_state['error']}",
                    destination=travel_request.destination
                )
            
            # Extract final response
            response_data = final_state.get("final_response", {})
            
            # Create response object
            response = TravelResponse(
                destination=response_data.get("destination", travel_request.destination),
                total_days=response_data.get("total_days", (travel_request.end_date - travel_request.start_date).days + 1),
                itinerary=response_data.get("itinerary", []),
                total_estimated_cost=response_data.get("total_estimated_cost"),
                recommendations=response_data.get("recommendations", []),
                weather_info=response_data.get("weather_info"),
                generated_at=response_data.get("generated_at", datetime.utcnow())
            )
            
            logger.info(f"Travel planning completed for {travel_request.destination}")
            return response
            
        except Exception as e:
            logger.error(f"Travel planning failed: {e}")
            raise TravelPlanningError(
                f"Failed to plan travel: {str(e)}",
                destination=travel_request.destination,
                operation="plan_travel"
            )


# Global agent instance
_travel_agent = None


def get_travel_agent() -> TravelPlanningAgent:
    """Get global travel planning agent instance."""
    global _travel_agent
    if _travel_agent is None:
        _travel_agent = TravelPlanningAgent()
    return _travel_agent


# Export agent and utilities
__all__ = [
    "TravelPlanningAgent",
    "AgentState", 
    "get_travel_agent",
]