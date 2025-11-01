"""
Response finalizer agent.

Handles:
- Converting structured itinerary to response format
- Building final TravelResponse with all components
- Error handling and fallback responses
"""

import structlog

from app.api.schemas import TravelResponse
from app.models.travel_models import TravelItinerary, DayItinerary, Activity, TransportationSuggestion
from app.agents.state import TravelPlanningState

logger = structlog.get_logger(__name__)


class ResponseAgent:
    """Agent responsible for finalizing response."""

    async def finalize_response(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 6: Build final response."""
        try:
            travel_request = state["travel_request"]
            structured_itinerary = state.get("structured_itinerary")

            logger.info(f"[Node 6/6] Finalizing response")

            # Check if structured_itinerary is None
            if not structured_itinerary:
                logger.error(f"[Node 6/6] No structured itinerary available for finalization")
                state["final_response"] = TravelResponse(
                    success=False,
                    message="Không thể tạo lịch trình - không tìm thấy đủ dữ liệu địa điểm",
                    itinerary=None
                )
                return state

            # Convert structured_itinerary to TravelItinerary object
            try:
                day_itineraries = []
                for day_data in structured_itinerary.get("days", []):
                    activities = []
                    for activity_data in day_data.get("activities", []):
                        # All activities must have place_id
                        activity = Activity(
                            time=activity_data.get("time", "09:00"),
                            name=activity_data.get("name", "Hoạt động chưa xác định"),
                            place_id=activity_data.get("place_id", ""),
                            duration_hours=activity_data.get("duration_hours", 1.0),
                            cost_estimate=activity_data.get("cost_estimate", 0.0),
                            notes=activity_data.get("notes", "")
                        )
                        activities.append(activity)

                    day_itinerary = DayItinerary(
                        day=day_data.get("day", 1),
                        date=day_data.get("date", travel_request.start_date.strftime("%Y-%m-%d")),
                        activities=activities
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
                    schedule_unavailable=structured_itinerary.get("schedule_unavailable", False),
                    unavailable_reason=structured_itinerary.get("unavailable_reason", "")
                )

            except Exception as conversion_error:
                logger.error(f"[Node 6/6] Failed to convert to TravelItinerary: {conversion_error}")
                state["final_response"] = TravelResponse(
                    success=False,
                    message=f"Lỗi chuyển đổi dữ liệu lịch trình: {str(conversion_error)}",
                    itinerary=None
                )
                return state

            response = TravelResponse(
                success=True,
                message="Lịch trình đã được tạo thành công",
                itinerary=travel_itinerary
            )

            state["final_response"] = response
            return state

        except Exception as e:
            logger.error(f"[Node 6/6] Failed: {e}")
            state["final_response"] = TravelResponse(
                success=False,
                message=f"Lỗi tạo phản hồi cuối cùng: {str(e)}",
                itinerary=None
            )
            return state


__all__ = ["ResponseAgent"]
