import { useQuery } from "@tanstack/react-query";
import { getAllProvinces } from "../../../services/apiProvince";
import { useSelector } from "react-redux";

export function useGetProvinces() {
	const filters = useSelector((state) => state.province.filters);

	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["provinces", filters],
		queryFn: () => getAllProvinces(filters),
	});

	return {
		provinces: data?.data?.data,
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
