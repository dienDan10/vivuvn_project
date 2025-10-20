import { useQuery } from "@tanstack/react-query";
import { getAllProvinces } from "../../../services/apiProvince";

export function useGetProvinces() {
	const { data, isPending, error, refetch } = useQuery({
		queryKey: ["provinces"],
		queryFn: getAllProvinces,
	});
	return { provinces: data?.data, isPending, error, refetch };
}
