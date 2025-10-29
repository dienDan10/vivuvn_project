import { useQuery } from "@tanstack/react-query";
import { getProvinceById } from "../../../services/apiProvince";

export function useGetProvinceById(id, enabled = true) {
	const { data, isPending, error } = useQuery({
		queryKey: ["province", id],
		queryFn: () => getProvinceById(id),
		enabled: !!id && enabled, // Only run when id exists and enabled is true
	});
	return { province: data?.data, isPending, error };
}
