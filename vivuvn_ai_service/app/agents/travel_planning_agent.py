"""
Main travel planning agent - orchestrates the workflow.

This is the entry point that coordinates all specialized agents:
- SearchAgent: Place discovery and filtering
- WeatherAgent: Weather data fetching
- ItineraryAgent: LLM-based itinerary generation
- ValidationAgent: Anti-hallucination checks
- ResponseAgent: Final response building

Uses LangGraph for workflow orchestration.
"""

import structlog
from typing import Optional

from langgraph.graph import StateGraph, END

from app.core.config import settings
from app.core.exceptions import TravelPlanningError
from app.api.schemas import TravelRequest, TravelResponse
from app.agents.state import TravelPlanningState
from app.agents.search_agent import SearchAgent
from app.agents.weather_agent import WeatherAgent
from app.agents.itinerary_agent import ItineraryAgent
from app.agents.validation_agent import ValidationAgent
from app.agents.response_agent import ResponseAgent

logger = structlog.get_logger(__name__)


class TravelPlanningAgent:
    """Main orchestrator for travel planning workflow."""

    def __init__(self):
        """Initialize main agent and all specialized agents."""
        self.search_agent = SearchAgent()
        self.weather_agent = WeatherAgent()
        self.itinerary_agent = ItineraryAgent()
        self.validation_agent = ValidationAgent()
        self.response_agent = ResponseAgent()

        self.workflow = self._build_workflow()

    def _build_workflow(self) -> StateGraph:
        """Build LangGraph workflow with all nodes and error-handling branches."""
        workflow = StateGraph(TravelPlanningState)

        workflow.add_node("build_filters", self.search_agent.build_search_filters)
        workflow.add_node("search_places", self.search_agent.search_places)
        workflow.add_node("fetch_weather_data", self.weather_agent.fetch_weather_data)
        workflow.add_node("generate_structured_itinerary", self.itinerary_agent.generate_structured_itinerary)
        workflow.add_node("validate_output", self.validation_agent.validate_output)
        workflow.add_node("finalize_response", self.response_agent.finalize_response)

        workflow.set_entry_point("build_filters")
        workflow.add_edge("build_filters", "search_places")

        # After search: check if places found
        def should_continue_after_search(state: TravelPlanningState) -> str:
            """Route after search_places: continue or skip to error response."""
            if state.get("error"):
                logger.warning(f"[Node 2/6] Critical error in search: {state['error']}")
                return "finalize_response"
            if not state.get("relevant_places"):
                logger.warning("[Node 2/6] No places found - cannot continue")
                return "finalize_response"
            return "fetch_weather_data"

        workflow.add_conditional_edges(
            "search_places",
            should_continue_after_search,
            {
                "fetch_weather_data": "fetch_weather_data",
                "finalize_response": "finalize_response"
            }
        )

        workflow.add_edge("fetch_weather_data", "generate_structured_itinerary")

        # After generation: check if itinerary created
        def should_continue_after_generation(state: TravelPlanningState) -> str:
            """Route after generate_structured_itinerary: continue or skip to error response."""
            if state.get("error"):
                logger.warning(f"[Node 4/6] Critical error in generation: {state['error']}")
                return "finalize_response"
            if not state.get("structured_itinerary"):
                logger.warning("[Node 4/6] No itinerary generated - cannot validate")
                return "finalize_response"
            return "validate_output"

        workflow.add_conditional_edges(
            "generate_structured_itinerary",
            should_continue_after_generation,
            {
                "validate_output": "validate_output",
                "finalize_response": "finalize_response"
            }
        )

        # After validation: check results
        def should_continue_after_validation(state: TravelPlanningState) -> str:
            """Route after validate_output: continue to response or skip."""
            if state.get("error"):
                logger.warning(f"[Node 5/6] Critical validation error: {state['error']}")
                return "finalize_response"
            if not state.get("validation_passed"):
                logger.warning("[Node 5/6] Validation failed - proceeding with warnings")
            return "finalize_response"

        workflow.add_conditional_edges(
            "validate_output",
            should_continue_after_validation,
            {
                "finalize_response": "finalize_response"
            }
        )

        workflow.add_edge("finalize_response", END)

        return workflow.compile()

    async def plan_travel(self, travel_request: TravelRequest) -> TravelResponse:
        """
        Main entry point: Run workflow with anti-hallucination.

        Args:
            travel_request: Travel planning request

        Returns:
            TravelResponse with structured itinerary and weather

        Raises:
            TravelPlanningError: If planning fails
        """
        try:
            logger.info(f"🚀 Starting workflow for {travel_request.destination}")

            initial_state: TravelPlanningState = {
                "travel_request": travel_request,
                "search_filters": {},
                "relevant_places": [],
                "place_clusters": [],
                "top_relevant_places": [],
                "weather_forecast": None,
                "weather_fetched": False,
                "structured_itinerary": None,
                "final_response": None,
                "error": None,
                "validation_passed": False
            }

            final_state = await self.workflow.ainvoke(initial_state)

            if final_state.get("error"):
                raise TravelPlanningError(final_state["error"])

            if not final_state.get("validation_passed"):
                logger.warning("⚠️ Validation detected potential hallucinations")

            response = final_state.get("final_response")
            if not response:
                raise TravelPlanningError("No response generated")

            logger.info(f"✅ Workflow complete for {travel_request.destination}")
            return response

        except Exception as e:
            logger.error(f"❌ Failed: {e}")
            raise TravelPlanningError(f"{str(e)}")


# ============================================================================
# SINGLETON
# ============================================================================

_travel_agent: Optional[TravelPlanningAgent] = None


def get_travel_agent() -> TravelPlanningAgent:
    """Get singleton travel planning agent."""
    global _travel_agent
    if _travel_agent is None:
        _travel_agent = TravelPlanningAgent()
    return _travel_agent


__all__ = [
    "TravelPlanningAgent",
    "get_travel_agent"
]
