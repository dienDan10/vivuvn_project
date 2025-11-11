import { useQuery } from "@tanstack/react-query";
import { getItineraryTrends } from "../../../services/apiDashboard";

/**
 * Custom hook to fetch itinerary creation trends
 * @param {Object} filters - Date range and groupBy filters
 * @returns {Object} Itinerary trends data and query state
 */
export function useGetItineraryTrends(filters = {}) {
	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["itineraryTrends", filters],
		queryFn: () => getItineraryTrends(filters),
		refetchInterval: 5 * 60 * 1000, // Auto-refresh every 5 minutes
	});

	return {
		trends: data?.data,
		isPending,
		error,
		refetch,
	};
}
