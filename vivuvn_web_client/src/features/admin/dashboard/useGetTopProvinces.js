import { useQuery } from "@tanstack/react-query";
import { getTopProvinces } from "../../../services/apiDashboard";

/**
 * Custom hook to fetch top provinces by visit count
 * @param {Object} filters - Date range and limit filters
 * @returns {Object} Top provinces data and query state
 */
export function useGetTopProvinces(filters = {}) {
	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["topProvinces", filters],
		queryFn: () => getTopProvinces(filters),
		refetchInterval: 5 * 60 * 1000, // Auto-refresh every 5 minutes
	});

	return {
		provinces: data?.data,
		isPending,
		error,
		refetch,
	};
}
