import { useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import {
  Card,
  Space,
  Typography,
  Button,
  Image,
  Descriptions,
  Tag,
  Alert,
  Skeleton,
  Empty,
  Row,
  Col,
  Breadcrumb,
  Popconfirm,
} from 'antd';
import {
  ArrowLeftOutlined,
  EditOutlined,
  DeleteOutlined,
  ReloadOutlined,
  GlobalOutlined,
  EnvironmentOutlined,
  EyeOutlined,
  StarOutlined,
  PictureOutlined,
} from '@ant-design/icons';
import { useGetDestinationById } from './useGetDestinationById';
import { useDeleteDestination } from './useDeleteDestination';
import { useRestoreDestination } from './useRestoreDestination';
import DestinationForm from './DestinationForm';
import { ERROR_NOTIFICATION } from '../../../utils/constant';

const { Title, Paragraph } = Typography;

function DestinationDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [modalOpen, setModalOpen] = useState(false);
  const [processing, setProcessing] = useState(false);

  const { destination, isPending, error, refetch } = useGetDestinationById(id);
  const { mutate: deleteDestination } = useDeleteDestination();
  const { mutate: restoreDestination } = useRestoreDestination();

  const handleEdit = () => {
    setModalOpen(true);
  };

  const handleFormClose = () => {
    setModalOpen(false);
  };

  const handleDelete = () => {
    setProcessing(true);
    deleteDestination(id, {
      onSuccess: () => {
        refetch();
      },
      onSettled: () => {
        setProcessing(false);
      },
    });
  };

  const handleRestore = () => {
    setProcessing(true);
    restoreDestination(id, {
      onSuccess: () => {
        refetch();
      },
      onSettled: () => {
        setProcessing(false);
      },
    });
  };

  // Error state
  if (error) {
    return (
      <Card>
        <Alert
          message="Error Loading Destination"
          description={error?.message || 'Failed to load destination details'}
          type={ERROR_NOTIFICATION}
          showIcon
          action={
            <Space>
              <Button size="small" onClick={() => navigate('/manage/destinations')}>
                Back to List
              </Button>
              <Button size="small" type="primary" onClick={() => refetch()}>
                Retry
              </Button>
            </Space>
          }
        />
      </Card>
    );
  }

  // Loading state
  if (isPending) {
    return (
      <Card>
        <Skeleton active paragraph={{ rows: 8 }} />
      </Card>
    );
  }

  // Not found state
  if (!destination) {
    return (
      <Card>
        <Empty
          description="Destination not found"
          image={Empty.PRESENTED_IMAGE_SIMPLE}
        >
          <Button type="primary" onClick={() => navigate('/manage/destinations')}>
            Back to Destinations
          </Button>
        </Empty>
      </Card>
    );
  }

  return (
    <Card>
      <Space direction="vertical" size="large" style={{ width: '100%' }}>
        {/* Breadcrumb */}
        <Breadcrumb
          items={[
            { title: <Link to="/manage/dashboard">Home</Link> },
            { title: <Link to="/manage/destinations">Destinations</Link> },
            { title: destination.name },
          ]}
        />

        {/* Header */}
        <Space
          direction="horizontal"
          style={{ width: '100%', justifyContent: 'space-between', flexWrap: 'wrap' }}
        >
          <Space>
            <Button
              icon={<ArrowLeftOutlined />}
              onClick={() => navigate('/manage/destinations')}
            >
              Back
            </Button>
            <Title level={2} style={{ margin: 0 }}>
              {destination.name}
            </Title>
            <Tag color="blue">{destination.provinceName}</Tag>
          </Space>

          <Space>
            {!destination.deleteFlag && (
              <Button
                type="primary"
                icon={<EditOutlined />}
                onClick={handleEdit}
              >
                Edit
              </Button>
            )}

            {!destination.deleteFlag ? (
              <Popconfirm
                title="Delete Destination"
                description="Are you sure you want to delete this destination?"
                onConfirm={handleDelete}
                okText="Yes"
                cancelText="No"
                okButtonProps={{ danger: true, loading: processing }}
              >
                <Button danger icon={<DeleteOutlined />} loading={processing}>
                  Delete
                </Button>
              </Popconfirm>
            ) : (
              <Button
                icon={<ReloadOutlined />}
                onClick={handleRestore}
                loading={processing}
              >
                Restore
              </Button>
            )}
          </Space>
        </Space>

        {/* Deleted Alert */}
        {destination.deleteFlag && (
          <Alert
            message="This destination is currently deleted"
            description="You can restore it using the restore button above."
            type="warning"
            showIcon
          />
        )}

        {/* Main Content */}
        <Row gutter={[24, 24]}>
          {/* Left: Images */}
          <Col xs={24} lg={10}>
            <Card title="Images" bordered={false}>
              {destination.photos && destination.photos.length > 0 ? (
                <Image.PreviewGroup>
                  <Space direction="vertical" size="middle" style={{ width: '100%' }}>
                    <Image
                      src={destination.photos[0]}
                      alt={destination.name}
                      style={{
                        width: '100%',
                        height: '300px',
                        objectFit: 'cover',
                        borderRadius: '8px',
                      }}
                    />
                    {destination.photos.length > 1 && (
                      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '8px' }}>
                        {destination.photos.slice(1).map((photo, index) => (
                          <Image
                            key={index}
                            src={photo}
                            alt={`${destination.name} ${index + 2}`}
                            style={{
                              width: '100%',
                              height: '100px',
                              objectFit: 'cover',
                              borderRadius: '4px',
                            }}
                          />
                        ))}
                      </div>
                    )}
                  </Space>
                </Image.PreviewGroup>
              ) : (
                <Empty
                  image={<PictureOutlined style={{ fontSize: 64, color: '#bfbfbf' }} />}
                  description="No images available"
                />
              )}
            </Card>
          </Col>

          {/* Right: Details */}
          <Col xs={24} lg={14}>
            <Space direction="vertical" size="middle" style={{ width: '100%' }}>
              {/* Basic Information */}
              <Card title="Details" bordered={false}>
                <Descriptions bordered column={1}>
                  <Descriptions.Item label="ID">{destination.id}</Descriptions.Item>
                  <Descriptions.Item label="Province">
                    <Tag color="blue">{destination.provinceName}</Tag>
                  </Descriptions.Item>
                  <Descriptions.Item label="Address">
                    {destination.address || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="Rating">
                    {destination.rating ? (
                      <Space size={4}>
                        <StarOutlined style={{ color: '#faad14' }} />
                        <span style={{ fontWeight: 500 }}>
                          {destination.rating.toFixed(1)}
                        </span>
                        {destination.ratingCount && (
                          <span style={{ color: '#888' }}>
                            ({destination.ratingCount} reviews)
                          </span>
                        )}
                      </Space>
                    ) : (
                      <span style={{ color: '#ccc' }}>No ratings yet</span>
                    )}
                  </Descriptions.Item>
                </Descriptions>
              </Card>

              {/* Description */}
              {destination.description && (
                <Card title="Description" bordered={false}>
                  <Paragraph>{destination.description}</Paragraph>
                </Card>
              )}

              {/* External Links */}
              <Card title="External Resources" bordered={false}>
                <Space wrap>
                  {destination.websiteUri && (
                    <Button
                      icon={<GlobalOutlined />}
                      onClick={() => window.open(destination.websiteUri, '_blank')}
                    >
                      Visit Website
                    </Button>
                  )}
                  {destination.directionsUri && (
                    <Button
                      icon={<EnvironmentOutlined />}
                      onClick={() => window.open(destination.directionsUri, '_blank')}
                    >
                      Get Directions
                    </Button>
                  )}
                  {destination.reviewUri && (
                    <Button
                      icon={<EyeOutlined />}
                      onClick={() => window.open(destination.reviewUri, '_blank')}
                    >
                      View Reviews
                    </Button>
                  )}
                  {!destination.websiteUri && !destination.directionsUri && !destination.reviewUri && (
                    <Empty description="No external links available" />
                  )}
                </Space>
              </Card>
            </Space>
          </Col>
        </Row>
      </Space>

      {/* Edit Modal */}
      <DestinationForm
        open={modalOpen}
        onClose={handleFormClose}
        destinationId={id}
        mode="edit"
      />
    </Card>
  );
}

export default DestinationDetail;
