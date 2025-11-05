"""
Search agent for place discovery and filtering.

Handles:
- Building search filters based on travel request
- Vector search with Pinecone
- Geographical clustering of results
"""

import structlog
from typing import Dict, List, Any

from app.core.config import settings
from app.core.exceptions import NoResultsError
from app.services.pinecone_service import get_pinecone_service
from app.services.embedding_service import get_embedding_service
from app.utils.geo_utils import simple_kmeans_geo
from app.utils.helpers import normalize_province_name
from app.agents.state import TravelPlanningState

logger = structlog.get_logger(__name__)


class SearchAgent:
    """Agent responsible for searching and filtering places."""

    def __init__(self):
        """Initialize search agent."""
        self.pinecone_service = get_pinecone_service()
        self.embedding_service = get_embedding_service()

        # Preference keywords mapping for semantic search
        # Keywords are words commonly found in place descriptions for each category
        self.preference_keywords = {
            "ẩm thực": ["nhà hàng", "quán ăn", "ẩm thực", "đặc sản"],
            "văn hóa": ["đền", "chùa", "bảo tàng", "di sản", "truyền thống"],
            "thiên nhiên": ["núi", "thác", "công viên", "hồ", "rừng", "hang động"],
            "phiêu lưu": ["leo núi", "chèo thuyền", "lặn"],
            "nhiếp ảnh": ["cảnh đẹp", "cảnh quan", "hoàng hôn", "bình minh"],
            "mua sắm": ["chợ", "thị trường", "mua sắm", "cửa hàng"],
            "thư giãn": ["spa", "resort", "biển", "bãi tắm"],
            "lịch sử": ["di tích", "bảo tàng", "thành cổ", "kiến trúc"],
            "đời sống về đêm": ["phố đi bộ", "bar", "chợ đêm", "giải trí"],
        }

    def _get_preference_keywords(self, preference: str) -> List[str]:
        """Get keywords for a preference category."""
        return self.preference_keywords.get(preference.lower(), [])

    def _build_semantic_query(self, travel_request) -> str:
        """
        Build semantic query focused on preferences.

        Note: Destination filtering is handled by province_filter in Node 1,
        so this query focuses only on preferences and special requirements.
        """
        if not travel_request.preferences:
            return "địa điểm du lịch"

        query_parts = []

        # Use primary preference as main query focus
        primary_pref = travel_request.preferences[0]
        query_parts.append(primary_pref)

        # Add 2-3 relevant keywords for better semantic matching with descriptions
        keywords = self._get_preference_keywords(primary_pref)
        query_parts.extend(keywords[:2])

        # Include special requirements if they're brief and focused
        if travel_request.special_requirements:
            special_req = travel_request.special_requirements.strip().lower()
            # Only add if it's a short, meaningful requirement (avoid noise)
            if special_req and len(special_req) < 50:
                query_parts.append(special_req)

        return " ".join(query_parts)

    def calculate_dynamic_top_k(self, duration_days: int) -> int:
        """
        Calculate optimal top_k based on trip duration (optimized for token efficiency).

        Formula: base + (activities_per_day * duration * diversity_factor)
        Reduced from previous values to minimize token usage while maintaining quality.

        Args:
            duration_days: Trip duration in days

        Returns:
            Optimized top_k value (clamped between min and max)

        Examples:
            1 day:  8 + (3.0 * 1 * 1.5) = 12-13
            3 days: 8 + (3.0 * 3 * 1.5) = 21-22
            7 days: 8 + (3.0 * 7 * 1.5) = 39-40 (capped at 35)
        """
        # Optimized formula: reduced diversity factor and activities per day
        calculated_k = int(
            settings.VECTOR_SEARCH_BASE_K +
            (3.0 * duration_days * 1.5)  # Reduced from 3.5 * 2.0 = 7.0 to 3.0 * 1.5 = 4.5
        )

        # Clamp between min and max (with tighter max)
        top_k = max(settings.VECTOR_SEARCH_MIN_K, min(calculated_k, 35))  # Reduced max from 50 to 35

        logger.info(f"Dynamic top_k: {duration_days} days → {top_k} places (calculated: {calculated_k})")
        return top_k

    async def build_search_filters(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 1: Build smart search filters based on travel request."""
        try:
            travel_request = state["travel_request"]

            logger.info(f"[Node 1/6] Building search filters for {travel_request.destination}")

            filters = {}
            additional_filters = {}

            # Province/Location filtering with normalization
            province = travel_request.destination.strip()

            if province:
                # Normalize the province name to handle cases where:
                # - User inputs "Hà Nội" but database has "Thành phố Hà Nội"
                # - User inputs "Thành phố Đà Nẵng" but database has "Đà Nẵng"
                normalized_province = normalize_province_name(province)
                filters["province"] = normalized_province

            # Place ID filtering (for specific place requests)
            if additional_filters:
                filters["additional_filters"] = additional_filters

            logger.info(f"[Node 1/6] Built filters: {filters}")

            # Store filters in state
            state["search_filters"] = filters

            return state

        except Exception as e:
            logger.error(f"[Node 1/6] Filter building failed: {e}")
            state["error"] = f"Filter building failed: {str(e)}"
            state["search_filters"] = {}
            return state

    async def search_places(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node 2: Search for grounded, verified places with smart filtering."""
        try:
            travel_request = state["travel_request"]
            filters = state.get("search_filters", {})

            # Calculate dynamic top_k based on trip duration
            duration_days = travel_request.duration_days
            dynamic_top_k = self.calculate_dynamic_top_k(duration_days)

            # Build semantic query focused on preferences
            search_query = self._build_semantic_query(travel_request)

            logger.info(f"[Node 2/6] Searching: {search_query} (duration: {duration_days} days, top_k: {dynamic_top_k})")

            # Generate embedding and search with filters
            query_embedding = await self.embedding_service._generate_embedding(
                search_query,
                task_type=settings.EMBEDDING_TASK_TYPE_QUERY
            )
            results = await self.pinecone_service.search_places(
                query_embedding=query_embedding,
                top_k=dynamic_top_k,
                province_filter=filters.get("province"),
                filter_dict=filters.get("additional_filters", {})
            )

            logger.info(f"[Node 2/6] Found {len(results)} places")

            if not results:
                error_msg = f"No places found for destination '{travel_request.destination}'. Try a different destination or broaden your search criteria."
                logger.error(
                    "[Node 2/6] No places found - cannot generate itinerary",
                    destination=travel_request.destination,
                    error_code="NO_RESULTS_FOUND"
                )
                state["error"] = error_msg
                state["relevant_places"] = []
                state["place_clusters"] = []
                state["top_relevant_places"] = []
                return state

            # Preserve top places by Pinecone score (for descriptions) BEFORE clustering
            top_by_score = sorted(results, key=lambda x: x.get('score', 0), reverse=True)[:5]

            try:
                # Auto-determine k based on number of results and trip duration
                suggested_k = min(4, max(2, duration_days // 2))
                clusters = simple_kmeans_geo(results, k=suggested_k)

                # Flatten clusters back to list (preserves geographical ordering)
                ordered_places = []
                for cluster in clusters:
                    ordered_places.extend(cluster)

                logger.info(f"[Node 2/6] Organized {len(results)} places into {len(clusters)} geographical clusters")

                state["relevant_places"] = ordered_places
                state["place_clusters"] = clusters
                state["top_relevant_places"] = top_by_score
            except Exception as cluster_error:
                logger.warning(f"[Node 2/6] Clustering failed: {cluster_error}, using original order")
                state["relevant_places"] = results
                state["place_clusters"] = []
                state["top_relevant_places"] = top_by_score

            return state

        except Exception as e:
            logger.error(
                "[Node 2/6] Search failed",
                destination=travel_request.destination,
                error=str(e),
                error_code="SEARCH_FAILED",
                exc_info=True
            )
            state["error"] = f"Search failed: {str(e)}"
            state["relevant_places"] = []
            return state


__all__ = ["SearchAgent"]
