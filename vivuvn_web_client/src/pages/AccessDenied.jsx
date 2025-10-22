import { Button, Result } from "antd";
import { useNavigate } from "react-router-dom";

function AccessDenied() {
	const navigate = useNavigate();
	return (
		<Result
			status="403"
			title="403"
			subTitle="Sorry, you are not authorized to access this page."
			extra={
				<Button
					color="default"
					variant="solid"
					onClick={() => navigate("/manage")}
				>
					Back To Dashboard
				</Button>
			}
		/>
	);
}

export default AccessDenied;
