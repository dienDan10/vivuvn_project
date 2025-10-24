import { useQuery } from "@tanstack/react-query";
// import { getAllTravelers } from "../../../services/apiTraveler";
import { useSelector } from "react-redux";
import { filterTravelers, delay } from "../../../mocks/travelerMockData";

export function useGetTravelers() {
	const filters = useSelector((state) => state.traveler.filters);

	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["travelers", filters],
		// Real API call:
		// queryFn: () => getAllTravelers(filters),
		// Mock data with delay:
		queryFn: async () => {
			await delay(500);
			return filterTravelers(filters);
		},
	});

	return {
		travelers: data?.data?.users || data?.data?.travelers,
		totalCount: data?.data?.totalCount,
		isPending,
		error,
		refetch,
	};
}
