import { useQuery } from "@tanstack/react-query";
import { getDashboardOverview } from "../../../services/apiDashboard";

/**
 * Custom hook to fetch dashboard overview statistics
 * @param {Object} filters - Date range filters
 * @returns {Object} Dashboard overview data and query state
 */
export function useGetDashboardOverview(filters = {}) {
	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["dashboardOverview", filters],
		queryFn: () => getDashboardOverview(filters),
		refetchInterval: 5 * 60 * 1000, // Auto-refresh every 5 minutes
	});

	return {
		overview: data?.data,
		isPending,
		error,
		refetch,
	};
}
