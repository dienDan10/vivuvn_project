"""
Travel agent for ViVu Vietnam AI Service using LangGraph workflow with structured output.

This module implements travel planning using:
- LangGraph for workflow orchestration
- Gemini Function Calling for structured JSON output
- Anti-hallucination: ONLY uses places from vector search
- Separate system/user prompts
- Direct JSON response (no parsing needed)
"""

import structlog
from typing import Dict, List, Any, Optional, TypedDict
from datetime import datetime, timedelta

from langgraph.graph import StateGraph, END
from google import genai
from google.genai import types
from pydantic import BaseModel

from app.core.config import settings
from app.core.exceptions import TravelPlanningError, ItineraryGenerationError
from app.api.schemas import TravelRequest, TravelResponse
from app.models.travel_models import Activity, DayItinerary, TravelItinerary
from app.services.vector_service import get_vector_service
from app.services.embedding_service import get_embedding_service
from app.prompts.travel_prompts import SYSTEM_PROMPT, create_user_prompt
# Cluster places geographically for better route optimization
from app.utils.geo_utils import simple_kmeans_geo
import asyncio

logger = structlog.get_logger(__name__)


# ============================================================================
# LANGGRAPH STATE
# ============================================================================

class TravelPlanningState(TypedDict):
    """Workflow state with validation flags."""
    travel_request: TravelRequest
    search_filters: Dict[str, Any]
    relevant_places: List[Dict[str, Any]]
    place_clusters: List[List[Dict[str, Any]]]  # Geographical clusters
    structured_itinerary: Optional[Dict[str, Any]]
    final_response: Optional[TravelResponse]
    error: Optional[str]
    validation_passed: bool  # Anti-hallucination check


# ============================================================================
# TRAVEL PLANNING AGENT
# ============================================================================

class TravelPlanningAgent:
    """LangGraph agent with function calling and anti-hallucination."""

    def __init__(self):
        """Initialize agent."""
        self.vector_service = get_vector_service()
        self.embedding_service = get_embedding_service()

        # Initialize Google AI client with modern SDK
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)
        
        # Pre-configure the model for reuse
        self.model = settings.GEMINI_MODEL
        self.generation_config = types.GenerateContentConfig(
            system_instruction=SYSTEM_PROMPT,
            response_mime_type="application/json",
            response_schema=TravelItinerary,
            temperature=settings.TEMPERATURE,
            max_output_tokens=settings.MAX_TOKENS
        )

        self.workflow = self._build_workflow()

    def _build_workflow(self) -> StateGraph:
        """Build LangGraph workflow with validation."""
        workflow = StateGraph(TravelPlanningState)

        workflow.add_node("search_places", self._search_places_node)
        workflow.add_node("build_filters", self._build_search_filters_node)
        workflow.add_node("generate_structured_itinerary", self._generate_structured_itinerary_node)
        workflow.add_node("validate_output", self._validate_output_node)  # Anti-hallucination
        workflow.add_node("finalize_response", self._finalize_response_node)


        workflow.set_entry_point("build_filters")
        workflow.add_edge("build_filters", "search_places")
        workflow.add_edge("search_places", "generate_structured_itinerary")
        workflow.add_edge("generate_structured_itinerary", "validate_output")
        workflow.add_edge("validate_output", "finalize_response")
        workflow.add_edge("finalize_response", END)

        return workflow.compile()

    def _calculate_dynamic_top_k(self, duration_days: int) -> int:
        """
        Calculate optimal top_k based on trip duration.

        Formula: base + (activities_per_day * duration * diversity_factor)
        Ensures sufficient place diversity while avoiding excessive fetches.

        Args:
            duration_days: Trip duration in days

        Returns:
            Optimized top_k value (clamped between min and max)

        Examples:
            1 day:  8 + (3.5 * 1 * 2.0) = 15
            3 days: 8 + (3.5 * 3 * 2.0) = 29
            7 days: 8 + (3.5 * 7 * 2.0) = 57 → capped at 50
        """
        # Calculate base top_k using config parameters
        calculated_k = int(
            settings.VECTOR_SEARCH_BASE_K +
            (settings.VECTOR_SEARCH_ACTIVITIES_PER_DAY * duration_days * settings.VECTOR_SEARCH_DIVERSITY_FACTOR)
        )

        # Clamp between min and max
        top_k = max(settings.VECTOR_SEARCH_MIN_K, min(calculated_k, settings.VECTOR_SEARCH_MAX_K))

        logger.info(f"Dynamic top_k: {duration_days} days → {top_k} places (calculated: {calculated_k})")
        return top_k

    # ========================================================================
    # NODES
    # ========================================================================

    async def _search_places_node(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 2: Search for grounded, verified places with smart filtering."""
        try:
            travel_request = state["travel_request"]
            filters = state.get("search_filters", {})

            # Calculate dynamic top_k based on trip duration
            duration_days = travel_request.duration_days
            dynamic_top_k = self._calculate_dynamic_top_k(duration_days)

            # Build comprehensive search query
            search_query = travel_request.destination
            if travel_request.preferences:
                search_query += f" {' '.join(travel_request.preferences)}"

            logger.info(f"[Node 2/5] Searching: {search_query} (duration: {duration_days} days, top_k: {dynamic_top_k})")

            # Generate embedding and search with filters
            query_embedding = self.embedding_service._generate_embedding(search_query)
            results = await self.vector_service.search_places(
                query_embedding=query_embedding,
                top_k=dynamic_top_k,  # Dynamic based on trip duration
                province_filter=filters.get("province"),
                min_rating=filters.get("min_rating"),
                place_ids=filters.get("place_ids", []),
                filter_dict=filters.get("additional_filters", {})
            )

            logger.info(f"[Node 2/5] Found {len(results)} places")

            if not results:
                logger.warning("[Node 2/5] No places found - risk of hallucination!")
                state["relevant_places"] = []
                state["place_clusters"] = []
                return state

            try:
                # Auto-determine k based on number of results and trip duration
                # More days = potentially need more geographical spread
                suggested_k = min(4, max(2, duration_days // 2))
                clusters = simple_kmeans_geo(results, k=suggested_k)

                # Flatten clusters back to list (preserves geographical ordering)
                ordered_places = []
                for cluster in clusters:
                    ordered_places.extend(cluster)

                logger.info(f"[Node 2/5] Organized {len(results)} places into {len(clusters)} geographical clusters")

                state["relevant_places"] = ordered_places
                state["place_clusters"] = clusters  # Store for prompt formatting
            except Exception as cluster_error:
                logger.warning(f"[Node 2/5] Clustering failed: {cluster_error}, using original order")
                state["relevant_places"] = results
                state["place_clusters"] = []

            return state

        except Exception as e:
            logger.error(f"[Node 2/5] Failed: {e}")
            state["error"] = f"Search failed: {str(e)}"
            state["relevant_places"] = []
            return state

    async def _generate_structured_itinerary_node(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 2: Generate itinerary with function calling."""
        try:
            travel_request = state["travel_request"]
            relevant_places = state.get("relevant_places", [])

            if not relevant_places:
                state["error"] = "No places available - cannot generate itinerary"
                return state

            logger.info(f"[Node 2/5] Generating with {len(relevant_places)} verified places")

            # Build user prompt with grounded data (with optional clusters)
            place_clusters = state.get("place_clusters", [])
            user_prompt = create_user_prompt(travel_request, relevant_places, place_clusters)

            # Call Gemini with structured output using modern SDK pattern
            response = await asyncio.get_event_loop().run_in_executor(
                None,
                lambda: self.client.models.generate_content(
                    model=self.model,
                    config=self.generation_config,
                    contents=user_prompt
                )
            )

            logger.info(response)

            # Get structured data directly from parsed response
            if not response.parsed:
                logger.error(f"[Node 2/5] No parsed response from Gemini")
                if response.text:
                    logger.error(f"[Node 2/5] Raw response: {response.text[:500]}...")
                raise ItineraryGenerationError("No structured response from Gemini")

            structured_itinerary: TravelItinerary = response.parsed

            # Convert to dictionary format for compatibility (using Pydantic v2 model_dump)
            structured_data = {
                "days": [day.model_dump() for day in structured_itinerary.days],
                "transportation_suggestions": [t.model_dump() for t in structured_itinerary.transportation_suggestions],
                "total_cost": structured_itinerary.total_cost,
                "places_used_count": structured_itinerary.places_used_count,
                "schedule_unavailable": structured_itinerary.schedule_unavailable,
                "unavailable_reason": structured_itinerary.unavailable_reason
            }

            logger.info(f"[Node 2/5] Generated {len(structured_data.get('days', []))} days, "
                       f"used {structured_data.get('places_used_count', 0)} database places")

            # Log budget validation status
            if structured_data.get('schedule_unavailable'):
                logger.warning(f"[Node 2/5] ⚠️ Budget exceeded: {structured_data.get('unavailable_reason', 'No reason provided')}")
            else:
                logger.info(f"[Node 2/5] ✅ Budget OK: {structured_data.get('total_cost', 0):,.0f} VND")

            state["structured_itinerary"] = structured_data
            return state

        except Exception as e:
            logger.error(f"[Node 2/5] Failed: {e}")
            state["error"] = f"Generation failed: {str(e)}"
            return state

    async def _validate_output_node(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 4: Validate output for hallucinations.

        Since all activities must have place_id (database requirement), validation
        now checks:
        1. Every activity has a non-empty place_id
        2. Activity names match database places (fuzzy match for minor variations)
        """
        try:
            structured_itinerary = state.get("structured_itinerary")
            relevant_places = state.get("relevant_places", [])

            # Check if structured_itinerary is None or empty
            if not structured_itinerary:
                logger.error(f"[Node 4/5] No structured itinerary to validate - previous generation failed")
                state["validation_passed"] = False
                state["error"] = "No itinerary generated to validate"
                return state

            # Extract place IDs and names from database
            db_place_ids = set()
            db_place_names = set()
            for place in relevant_places:
                place_id = place.get('metadata', {}).get('place_id', '')
                name = place.get('metadata', {}).get('name', '')
                if place_id:
                    db_place_ids.add(place_id.strip())
                if name:
                    db_place_names.add(name.lower().strip())

            # Check each activity
            days = structured_itinerary.get('days', [])
            missing_place_id_count = 0
            hallucinated_count = 0
            validated_count = 0
            total_activities = 0

            for day in days:
                for activity in day.get('activities', []):
                    total_activities += 1
                    activity_place_id = activity.get('place_id', '').strip()
                    activity_name = activity.get('name', '').lower().strip()

                    # Check 1: Must have place_id (critical for DB foreign key)
                    if not activity_place_id:
                        missing_place_id_count += 1
                        logger.warning(f"[Node 4/5] ❌ Missing place_id: '{activity.get('name')}'")
                        continue

                    # Check 2: place_id should match database (exact match)
                    if activity_place_id not in db_place_ids:
                        hallucinated_count += 1
                        logger.warning(f"[Node 4/5] ⚠️ Unknown place_id: '{activity_place_id}' for '{activity.get('name')}'")
                        continue

                    # Check 3: Activity name should match database place (fuzzy match)
                    found = False
                    for db_name in db_place_names:
                        if db_name in activity_name or activity_name in db_name:
                            found = True
                            validated_count += 1
                            break

                    if not found:
                        logger.warning(f"[Node 4/5] ⚠️ Name mismatch (but place_id OK): '{activity.get('name')}'")
                        # Don't count as hallucination if place_id is valid
                        validated_count += 1

            # Log validation results
            logger.info(f"[Node 4/5] Validation: {validated_count}/{total_activities} verified, "
                       f"{missing_place_id_count} missing place_id, {hallucinated_count} unknown place_id")

            # Pass validation if all activities have valid place_id
            state["validation_passed"] = (missing_place_id_count == 0 and hallucinated_count == 0)

            if missing_place_id_count > 0:
                logger.error(f"[Node 4/5] ❌ CRITICAL: {missing_place_id_count} activities missing place_id (DB requirement)")

            if hallucinated_count > 0:
                logger.warning(f"[Node 4/5] ⚠️ Found {hallucinated_count} activities with unknown place_id")

            return state

        except Exception as e:
            logger.error(f"[Node 4/5] Validation failed: {e}")
            state["validation_passed"] = False
            return state

    async def _finalize_response_node(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 5: Build final response."""
        try:
            travel_request = state["travel_request"]
            structured_itinerary = state.get("structured_itinerary")

            logger.info(f"[Node 5/5] Finalizing response")

            # Check if structured_itinerary is None
            if not structured_itinerary:
                logger.error(f"[Node 5/5] No structured itinerary available for finalization")
                state["final_response"] = TravelResponse(
                    success=False,
                    message="Không thể tạo lịch trình - không tìm thấy đủ dữ liệu địa điểm",
                    itinerary=None,
                    weather_info=self._get_weather_info(travel_request)
                )
                return state

            # Convert structured_itinerary to TravelItinerary object
            try:
                # Create TravelItinerary from the structured data
                from app.models.travel_models import TravelItinerary, DayItinerary, Activity, TransportationSuggestion

                day_itineraries = []
                for day_data in structured_itinerary.get("days", []):
                    activities = []
                    for activity_data in day_data.get("activities", []):
                        # All activities must have place_id (from_database field removed)
                        activity = Activity(
                            time=activity_data.get("time", "09:00"),
                            name=activity_data.get("name", "Hoạt động chưa xác định"),
                            place_id=activity_data.get("place_id", ""),
                            duration_hours=activity_data.get("duration_hours", 1.0),
                            cost_estimate=activity_data.get("cost_estimate", 0.0),
                            category=activity_data.get("category", "sightseeing")
                        )
                        activities.append(activity)

                    day_itinerary = DayItinerary(
                        day=day_data.get("day", 1),
                        date=day_data.get("date", travel_request.start_date.strftime("%Y-%m-%d")),
                        activities=activities,
                        estimated_cost=day_data.get("estimated_cost"),
                        notes=day_data.get("notes", "Ghi chú cho ngày này")
                    )
                    day_itineraries.append(day_itinerary)

                # Create transportation suggestions
                transportation_suggestions = structured_itinerary.get("transportation_suggestions", [])
                transport_objects = []
                for transport_data in transportation_suggestions:
                    transport = TransportationSuggestion(
                        mode=transport_data.get("mode", "xe khách"),
                        estimated_cost=transport_data.get("estimated_cost", 0.0),
                        date=transport_data.get("date", travel_request.start_date.strftime("%Y-%m-%d")),
                        details=transport_data.get("details", "Chi tiết sẽ được cập nhật")
                    )
                    transport_objects.append(transport)
                
                travel_itinerary = TravelItinerary(
                    days=day_itineraries,
                    transportation_suggestions=transport_objects,
                    total_cost=structured_itinerary.get("total_cost", 0.0),
                    places_used_count=structured_itinerary.get("places_used_count", 0),
                    schedule_unavailable=structured_itinerary.get("schedule_unavailable", False),
                    unavailable_reason=structured_itinerary.get("unavailable_reason", "")
                )
                
            except Exception as conversion_error:
                logger.error(f"[Node 5/5] Failed to convert to TravelItinerary: {conversion_error}")
                state["final_response"] = TravelResponse(
                    success=False,
                    message=f"Lỗi chuyển đổi dữ liệu lịch trình: {str(conversion_error)}",
                    itinerary=None,
                    recommendations=[],
                    weather_info=self._get_weather_info(travel_request)
                )
                return state

            response = TravelResponse(
                success=True,
                message="Lịch trình đã được tạo thành công",
                itinerary=travel_itinerary,
                recommendations=[],
                weather_info=self._get_weather_info(travel_request)
            )

            state["final_response"] = response
            return state

        except Exception as e:
            logger.error(f"[Node 5/5] Failed: {e}")
            state["final_response"] = TravelResponse(
                success=False,
                message=f"Lỗi tạo phản hồi cuối cùng: {str(e)}",
                itinerary=None,
                recommendations=[],
                weather_info="Thông tin thời tiết không có sẵn"
            )
            return state

    async def _build_search_filters_node(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 1: Build smart search filters based on travel request."""
        try:
            travel_request = state["travel_request"]
            
            logger.info(f"[Node 1/5] Building search filters for {travel_request.destination}")
            
            filters = {}
            additional_filters = {}
            
            # Province/Location filtering
            province = travel_request.destination.strip()
            if province:
                filters["province"] = province
                logger.info(f"[Node 1/5] Province filter: {province}")
            
            # Preference-based smart filtering (future enhancement)
            if travel_request.preferences:
                logger.info(f"[Node 1/5] Preferences noted: {travel_request.preferences}")
                # Can be expanded to filter by categories when available in data
            
            # Place ID filtering (for specific place requests)
            # Can be extended to filter by specific place IDs if needed
            if additional_filters:
                filters["additional_filters"] = additional_filters

            logger.info(f"[Node 1/5] Built filters: {filters}")
                
            # Store filters in state
            state["search_filters"] = filters
            
            return state
            
        except Exception as e:
            logger.error(f"[Node 1/5] Filter building failed: {e}")
            state["error"] = f"Filter building failed: {str(e)}"
            state["search_filters"] = {}
            return state

    def _get_weather_info(self, travel_request: TravelRequest) -> str:
        """Get weather for travel month."""
        weather = {
            1: "Cool and dry, 15-25°C", 2: "Cool and dry, 16-26°C",
            3: "Warm, 20-30°C", 4: "Warm and humid, 25-32°C",
            5: "Hot and humid, 26-35°C, rainy season", 6: "Hot and wet, 26-33°C",
            7: "Hot and wet, 26-33°C, peak rain", 8: "Hot and wet, 26-33°C",
            9: "Warm and wet, 25-32°C", 10: "Warm, 23-30°C",
            11: "Pleasant, 20-28°C, dry", 12: "Cool and dry, 17-26°C, ideal"
        }
        return weather.get(travel_request.start_date.month, "Weather info unavailable")

    # ========================================================================
    # PUBLIC API
    # ========================================================================

    async def plan_travel(self, travel_request: TravelRequest) -> TravelResponse:
        """
        Main entry: Run workflow with anti-hallucination.

        Returns structured JSON from Gemini, validated against database.
        """
        try:
            logger.info(f"🚀 Starting workflow for {travel_request.destination}")

            initial_state: TravelPlanningState = {
                "travel_request": travel_request,
                "search_filters": {},
                "relevant_places": [],
                "place_clusters": [],
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
            raise TravelPlanningError(f"Planning failed: {str(e)}")


# ============================================================================
# EXPORTS
# ============================================================================

_travel_agent: Optional[TravelPlanningAgent] = None


def get_travel_agent() -> TravelPlanningAgent:
    """Get singleton agent."""
    global _travel_agent
    if _travel_agent is None:
        _travel_agent = TravelPlanningAgent()
    return _travel_agent


__all__ = [
    "TravelPlanningAgent",
    "get_travel_agent",
    "TravelPlanningState"
]