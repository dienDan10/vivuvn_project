"""
Validation agent for anti-hallucination checks.

Handles:
- Validating generated activities against database places
- Checking place_id validity
- Detecting hallucinated content
"""

from typing import Optional, Tuple

import structlog

from app.agents.state import TravelPlanningState

logger = structlog.get_logger(__name__)


class ValidationAgent:
    """Agent responsible for validating itinerary outputs."""

    async def validate_output(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 5: Validate output for hallucinations.

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
                logger.error(f"[Node 5/6] No structured itinerary to validate - previous generation failed")
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
                        logger.warning(f"[Node 5/6] ❌ Missing place_id: '{activity.get('name')}'")
                        continue

                    # Check 2: place_id should match database (exact match)
                    if activity_place_id not in db_place_ids:
                        hallucinated_count += 1
                        logger.warning(f"[Node 5/6] ⚠️ Unknown place_id: '{activity_place_id}' for '{activity.get('name')}'")
                        continue

                    # Check 3: Activity name should match database place (fuzzy match)
                    found = False
                    for db_name in db_place_names:
                        if db_name in activity_name or activity_name in db_name:
                            found = True
                            validated_count += 1
                            break

                    if not found:
                        logger.warning(f"[Node 5/6] ⚠️ Name mismatch (but place_id OK): '{activity.get('name')}'")
                        # Don't count as hallucination if place_id is valid
                        validated_count += 1

            # Log validation results
            logger.info(f"[Node 5/6] Validation: {validated_count}/{total_activities} verified, "
                       f"{missing_place_id_count} missing place_id, {hallucinated_count} unknown place_id")

            # Pass validation if all activities have valid place_id
            state["validation_passed"] = (missing_place_id_count == 0 and hallucinated_count == 0)

            # Set error if validation fails (critical failures only)
            if missing_place_id_count > 0:
                error_msg = f"Validation failed: {missing_place_id_count} activities missing place_id (database requirement)"
                logger.error(f"[Node 5/6] ❌ CRITICAL: {error_msg}")
                state["error"] = error_msg

            if hallucinated_count > 0 and not state.get("error"):
                # Only set as error if it's not already set by missing place_id
                error_msg = f"Validation failed: {hallucinated_count} activities with invalid place_id"
                logger.error(f"[Node 5/6] ❌ CRITICAL: {error_msg}")
                state["error"] = error_msg

            # Correct total_cost and schedule_unavailable if needed
            # This ensures cost is calculated correctly and schedule availability is accurate
            self._correct_cost_and_availability(state)

            return state

        except Exception as e:
            error_message = getattr(e, 'message', str(e))
            logger.error(
                "[Node 5/6] Validation failed",
                error=error_message,
                error_code="VALIDATION_FAILED",
                exc_info=True
            )
            state["validation_passed"] = False
            state["error"] = f"Validation failed: {error_message}"
            return state

    def _calculate_total_cost(self, itinerary: dict, group_size: int) -> float:
        """Calculate total cost using correct formula.

        Formula: total_cost = (Σ activity.cost_estimate) + (Σ transportation.estimated_cost)

        Note: Both activity cost_estimate and transportation estimated_cost are TOTAL for entire group.
        group_size parameter kept for backwards compatibility but not used in calculation.
        """
        try:
            # Sum all activity costs (already total for group)
            activity_costs = 0.0
            days = itinerary.get('days', [])
            for day in days:
                for activity in day.get('activities', []):
                    cost = activity.get('cost_estimate', 0)
                    if isinstance(cost, (int, float)):
                        activity_costs += float(cost)

            # Sum all transportation costs (already total for group)
            transportation_costs = 0.0
            for transport in itinerary.get('transportation_suggestions', []):
                cost = transport.get('estimated_cost', 0)
                if isinstance(cost, (int, float)):
                    transportation_costs += float(cost)

            # Calculate total (both already for group, no multiplication needed)
            total_cost = activity_costs + transportation_costs
            return total_cost

        except Exception as e:
            logger.error(
                "[Node 5/6] Cost calculation failed",
                error=str(e),
                exc_info=True
            )
            # Return AI's value as fallback
            return itinerary.get('total_cost', 0.0)

    def _validate_budget_constraints(
        self,
        itinerary: dict,
        budget: Optional[int],
        calculated_cost: float
    ) -> Tuple[bool, str]:
        """Validate if itinerary respects budget constraints.

        Returns:
            Tuple of (should_be_unavailable: bool, unavailable_reason: str)
        """
        # If no budget specified, no constraint
        if budget is None:
            return False, ""

        # Check if cost exceeds budget
        should_be_unavailable = calculated_cost > budget

        if should_be_unavailable:
            reason = f"Tổng chi phí {calculated_cost:,.0f} VND vượt ngân sách {budget:,.0f} VND"
            return True, reason

        return False, ""

    def _correct_cost_and_availability(self, state: TravelPlanningState) -> None:
        """Correct total_cost and schedule_unavailable fields after validation.

        This method ensures the cost calculation is correct and the schedule availability
        is accurate based on the corrected cost vs budget.
        """
        try:
            structured_itinerary = state.get("structured_itinerary")
            travel_request = state.get("travel_request")

            if not structured_itinerary or not travel_request:
                return

            group_size = travel_request.group_size
            budget = travel_request.budget

            # Calculate correct total cost
            calculated_cost = self._calculate_total_cost(structured_itinerary, group_size)
            ai_total_cost = structured_itinerary.get('total_cost', 0.0)

            # Log if AI's calculation differs
            cost_diff = abs(calculated_cost - ai_total_cost)
            if cost_diff > 1000:  # Only log significant differences (>1000 VND)
                logger.warning(
                    "[Node 5/6] Cost calculation discrepancy detected",
                    ai_calculated=ai_total_cost,
                    recalculated=calculated_cost,
                    difference=cost_diff,
                    group_size=group_size
                )

            # Update with correct cost
            structured_itinerary['total_cost'] = calculated_cost

            # Validate budget constraints
            should_be_unavailable, unavailable_reason = self._validate_budget_constraints(
                structured_itinerary,
                budget,
                calculated_cost
            )

            ai_schedule_unavailable = structured_itinerary.get('schedule_unavailable', False)

            # Check if AI's decision matches correct decision
            if should_be_unavailable != ai_schedule_unavailable:
                logger.warning(
                    "[Node 5/6] Schedule availability mismatch - correcting",
                    ai_decision=ai_schedule_unavailable,
                    corrected_decision=should_be_unavailable,
                    calculated_cost=calculated_cost,
                    budget=budget
                )
                structured_itinerary['schedule_unavailable'] = should_be_unavailable
                structured_itinerary['unavailable_reason'] = unavailable_reason

        except Exception as e:
            logger.error(
                "[Node 5/6] Cost and availability correction failed",
                error=str(e),
                exc_info=True
            )
            # Continue with AI's original values on error


__all__ = ["ValidationAgent"]
