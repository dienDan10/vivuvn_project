import { useQuery } from "@tanstack/react-query";
import { getProvinceById } from "../../../services/apiProvince";

export function useGetProvinceById(id) {
  const { data, isPending, error } = useQuery({
    queryKey: ["province", id],
    queryFn: () => getProvinceById(id),
  });
  return { province: data?.data, isPending, error };
}
