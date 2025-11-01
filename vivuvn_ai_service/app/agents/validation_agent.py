"""
Validation agent for anti-hallucination checks.

Handles:
- Validating generated activities against database places
- Checking place_id validity
- Detecting hallucinated content
"""

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

            if missing_place_id_count > 0:
                logger.error(f"[Node 5/6] ❌ CRITICAL: {missing_place_id_count} activities missing place_id (DB requirement)")

            if hallucinated_count > 0:
                logger.warning(f"[Node 5/6] ⚠️ Found {hallucinated_count} activities with unknown place_id")

            return state

        except Exception as e:
            logger.error(f"[Node 5/6] Validation failed: {e}")
            state["validation_passed"] = False
            return state


__all__ = ["ValidationAgent"]
