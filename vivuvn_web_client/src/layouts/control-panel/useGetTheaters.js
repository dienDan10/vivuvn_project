import { useQuery } from "@tanstack/react-query";
import { getAllTheaters } from "../../services/apiTheater";

export function useGetTheaters() {
  const { data, isPending, error } = useQuery({
    queryKey: ["theaters"],
    queryFn: getAllTheaters,
  });

  return { theaters: data?.data || [], isPending, error };
}
