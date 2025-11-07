import { useQuery } from "@tanstack/react-query";
import { getAllProvincesNoPagination } from "../../../services/apiProvince";

export function useGetAllProvinces() {
    const { data, isPending, error, refetch } = useQuery({
		queryKey: ["provinces"],
		queryFn: () => getAllProvincesNoPagination(),
	});

	return {
		provinces: data?.data,
		isPending,
		error,
		refetch,
	};
}
