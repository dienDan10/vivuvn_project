import { useQuery } from "@tanstack/react-query";
import { getTopLocations } from "../../../services/apiDashboard";

/**
 * Custom hook to fetch top locations by visit count
 * @param {Object} filters - Date range and limit filters
 * @returns {Object} Top locations data and query state
 */
export function useGetTopLocations(filters = {}) {
	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["topLocations", filters],
		queryFn: () => getTopLocations(filters),
		refetchInterval: 5 * 60 * 1000, // Auto-refresh every 5 minutes
	});

	return {
		locations: data?.data,
		isPending,
		error,
		refetch,
	};
}
