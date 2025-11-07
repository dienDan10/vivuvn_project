import { useQuery } from "@tanstack/react-query";
import { getAllDestinations } from "../../../services/apiDestination";
import { useSelector } from "react-redux";

export function useGetDestinations() {
	const filters = useSelector((state) => state.destination.filters);

	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["destinations", filters],
		queryFn: () => getAllDestinations(filters),
	});

	return {
		destinations: data?.data?.data,
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
