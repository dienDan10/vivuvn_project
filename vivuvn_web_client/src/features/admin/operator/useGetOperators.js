import { useQuery } from "@tanstack/react-query";
import { useSelector } from "react-redux";
import { getAllOperators } from "../../../services/apiOperator";

export function useGetOperators() {
	const filters = useSelector((state) => state.operator.filters);

	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["operators", filters],
		queryFn: () => getAllOperators(filters),
	});

	return {
		operators: data?.data?.data,
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
