import { Button, Result } from "antd";

function AccessDenied() {
	return (
		<Result
			status="403"
			title="403"
			subTitle="Sorry, you are not authorized to access this page."
			extra={[
				<Button key="home" onClick={() => window.location.href = "/manage"}>
					Go to Home
				</Button>,
				<Button
					key="login"
					type="primary"
					onClick={() => window.location.href = "/login"}
				>
					Back To Login
				</Button>,
			]}
		/>
	);
}

export default AccessDenied;
