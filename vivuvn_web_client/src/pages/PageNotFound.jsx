import { Button, Result } from "antd";
import { useNavigate } from "react-router-dom";

function PageNotFound() {
  const navigate = useNavigate();
  return (
    <Result
      status="404"
      title="404"
      subTitle="Sorry, the page you visited does not exist."
      style={{ marginTop: 100 }}
      extra={
        <Button type="primary" onClick={() => navigate("/")}>
          Go To Home
        </Button>
      }
    />
  );
}

export default PageNotFound;
