import { useQuery } from "@tanstack/react-query";
import { getUserProfile } from "../../services/apiUser";
import { useSelector } from "react-redux";
import tokenManager from "../../utils/tokenManager";

export function useProfile() {
	const { isAuthenticated } = useSelector((state) => state.user);

	const { data, isPending, isError } = useQuery({
		queryKey: ["userProfile"],
		queryFn: getUserProfile,
		retry: false,
		enabled: isAuthenticated && tokenManager.hasValidTokens(), // Only fetch when authenticated and has tokens
	});

	return {
		data,
		isPending,
		isError,
	};
}
