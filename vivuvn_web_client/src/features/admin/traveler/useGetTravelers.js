import { useQuery } from "@tanstack/react-query";
// import { getAllTravelers } from "../../../services/apiTraveler";
import { useSelector } from "react-redux";
import { getAllTravelers } from "../../../services/apiTraveler";

export function useGetTravelers() {
	const filters = useSelector((state) => state.traveler.filters);

	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["travelers", filters],
		queryFn: () => getAllTravelers(filters),
	});

	return {
		travelers: data?.data?.data,
		totalCount: data?.data?.totalCount,
		pageNumber: data?.data?.pageNumber,
		pageSize: data?.data?.pageSize,
		totalPages: data?.data?.totalPages,
		hasPreviousPage: data?.data?.hasPreviousPage,
		hasNextPage: data?.data?.hasNextPage,
		isPending,
		error,
		refetch,
	};
}
