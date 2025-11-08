import { useQuery } from "@tanstack/react-query";
import { getDestinationById } from "../../../services/apiDestination";

export function useGetDestinationById(id, enabled = true) {
	const { data, isPending, error } = useQuery({
		queryKey: ["destination", id],
		queryFn: () => getDestinationById(id),
		enabled: !!id && enabled, // Only run when id exists and enabled is true
	});

	return {
		destination: data?.data,
		isPending,
		error,
	};
}
