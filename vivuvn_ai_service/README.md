# ViVu Vietnam AI Service 🇻🇳

> **AI-Powered Travel Itinerary Generator for Vietnam Destinations**

Một dịch vụ AI độc lập (standalone) được xây dựng với FastAPI, Pinecone Serverless, và Google Gemini để tạo lịch trình du lịch Việt Nam thông minh và cá nhân hóa.

[![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.117+-green.svg)](https://fastapi.tiangolo.com)
[![Pinecone](https://img.shields.io/badge/Pinecone-Serverless-orange.svg)](https://pinecone.io)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🌟 **Tính năng chính**

- 🤖 **AI-Powered Generation**: Sử dụng Google Gemini với RAG pattern
- 🇻🇳 **Chuyên biệt Việt Nam**: Kiến thức sâu về du lịch, văn hóa Việt Nam
- ⚡ **Vector Search**: Tìm kiếm ngữ nghĩa với Pinecone Serverless
- 🚀 **Standalone Service**: Không cần database, chỉ cần API keys
- 📊 **Data Management**: API để quản lý dữ liệu du lịch
- 💰 **Cost Estimation**: Ước tính chi phí thực tế tính bằng VND

---

## 🏗️ **Kiến trúc hệ thống**

```
┌────────────────────────────────────────────────────────────────┐
│                    ViVu Vietnam AI Service                     │
├────────────────────────────────────────────────────────────────┤
│  🌐 FastAPI REST API                                          │
│  ├── Travel Planning Endpoints                                │
│  ├── Data Management Endpoints                                │
│  └── Health Check & Monitoring                                │
├────────────────────────────────────────────────────────────────┤
│  🤖 AI Services                                               │
│  ├── Google Gemini (Content Generation)                       │
│  ├── Sentence Transformers (Embeddings)                       │
│  └── LangChain/LangGraph (Orchestration)                      │
├────────────────────────────────────────────────────────────────┤
│  ☁️ External Services                                         │
│  ├── Pinecone Serverless (Vector Storage)                     │
│  └── Google AI API (LLM)                                      │
└────────────────────────────────────────────────────────────────┘
```

---

## 📁 **Cấu trúc thư mục**

```
vivuvn_ai_service/
├── app/                          # Main application
│   ├── api/                      # API routes and schemas
│   │   ├── routes/               # API endpoints
│   │   │   ├── travel_planner.py # Travel itinerary generation
│   │   │   └── data_management.py# Data CRUD operations
│   │   └── schemas.py            # Pydantic models
│   ├── core/                     # Core configuration
│   │   ├── config.py             # Settings and environment
│   │   ├── database.py           # Minimal database setup
│   │   └── exceptions.py         # Custom exceptions
│   ├── services/                 # Business logic
│   │   ├── vector_service.py     # Pinecone vector operations
│   │   └── travel_agent.py       # AI travel planning
│   ├── utils/                    # Utilities
│   │   ├── data_loader.py        # Data loading into Pinecone
│   │   └── helpers.py            # Helper functions
│   └── main.py                   # FastAPI application
├── requirements.txt              # Python dependencies
├── pyproject.toml               # Project configuration
├── .env.example                 # Environment template
└── README.md                    # This file
```

---

## ⚙️ **Cài đặt và chạy dự án**

### 📋 **Yêu cầu hệ thống**

- **Python**: 3.9 hoặc cao hơn
- **API Keys**:
  - [Pinecone API Key](https://www.pinecone.io/) (Serverless - Miễn phí)
  - [Google Gemini API Key](https://aistudio.google.com/app/apikey) (Miễn phí)

### 🚀 **Cài đặt nhanh**

#### **Bước 1: Clone repository**
```bash
git clone https://github.com/vivuvn/vivuvn_ai_service.git
cd vivuvn_ai_service
```

#### **Bước 2: Tạo Virtual Environment**
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/macOS  
python3 -m venv venv
source venv/bin/activate
```

#### **Bước 3: Cài đặt dependencies** ⚡
```bash
# Upgrade pip trước
python -m pip install --upgrade pip

# Cài đặt tất cả dependencies
pip install -r requirements.txt

# Hoặc cài từ pyproject.toml
pip install -e .
```

#### **Bước 4: Cấu hình Environment Variables**
```bash
# Copy file mẫu
cp .env.example .env

# Chỉnh sửa file .env
notepad .env  # Windows
nano .env     # Linux/macOS
```

**Nội dung file `.env`:**
```bash
# AI Configuration
GEMINI_API_KEY=your_gemini_api_key_here

# Pinecone Serverless Configuration  
PINECONE_API_KEY=your_pinecone_api_key_here
PINECONE_INDEX_NAME=vivuvn-travel
PINECONE_CLOUD=aws
PINECONE_REGION=us-east-1

# Vector Configuration
VECTOR_DIMENSION=384
EMBEDDING_MODEL=all-MiniLM-L6-v2

# Application Settings
DEBUG=false
LOG_LEVEL=INFO
PORT=8000
```

#### **Bước 5: Chạy ứng dụng** 🚀
```bash
# Cách 1: Chạy trực tiếp
python -m app.main
```

#### **Bước 6: Kiểm tra hoạt động** ✅
```bash
# Kiểm tra health endpoint
curl http://localhost:8000/health

# Truy cập API documentation
# http://localhost:8000/docs (Swagger UI)
# http://localhost:8000/redoc (ReDoc)
```

---

## 🧪 **Kiểm tra cài đặt**

### **Kiểm tra imports:**
```bash
python -c "
from app.core.config import settings
from app.services.vector_service import get_vector_service  
from app.utils.data_loader import get_data_loader
print('✅ All imports successful!')
"
```

### **Kiểm tra dependencies:**
```bash
python -c "
import fastapi, pydantic, langchain, pinecone
print('✅ Core libraries OK!')
"
```

### **Script kiểm tra toàn diện:**
```bash
python -c "
print('=== ViVu AI Service Health Check ===')
try:
    from app.core.config import settings
    print(f'✅ Config loaded - Debug: {settings.DEBUG}')
    
    from app.services.vector_service import get_vector_service
    print('✅ Vector service ready')
    
    from app.main import app
    print('✅ FastAPI app ready')
    
    import fastapi, pydantic, langchain
    print('✅ All dependencies installed')
    
    print('🎉 READY TO RUN!')
except Exception as e:
    print(f'❌ Error: {e}')
    print('Run: pip install -r requirements.txt')
"
```

---

## 📚 **API Documentation**

### **🧳 Travel Planning**

#### **Generate Itinerary**
```bash
POST /api/v1/travel/generate-itinerary
```

**Request:**
```json
{
  "destinations": ["Ho Chi Minh City", "Hoi An"],
  "duration_days": 7,
  "budget_vnd": 15000000,
  "interests": ["culture", "food", "history"],
  "travel_style": "backpacker"
}
```

**Response:**
```json
{
  "itinerary": [
    {
      "day": 1,
      "location": "Ho Chi Minh City",
      "activities": [
        {
          "time": "09:00",
          "name": "War Remnants Museum",
          "description": "Learn about Vietnam War history",
          "cost_estimate": 15000,
          "duration": "2 hours"
        }
      ],
      "accommodation": "Budget hostel in District 1",
      "daily_cost": 800000
    }
  ],
  "total_cost_vnd": 5600000,
  "suggestions": ["Try local street food", "Book train to Hoi An in advance"]
}
```

### **📊 Data Management**

#### **Insert Single Item**
```bash
POST /api/v1/data/insert
```

#### **Batch Upload**
```bash
POST /api/v1/data/batch-upload
```

#### **Delete Item**
```bash
DELETE /api/v1/data/delete
```

#### **Get Statistics**
```bash
GET /api/v1/data/stats
```

---

## 🎯 **Sử dụng**

### **1. Tạo lịch trình du lịch:**
```python
import httpx

async def generate_itinerary():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "http://localhost:8000/api/v1/travel/generate-itinerary",
            json={
                "destinations": ["Da Nang", "Hoi An"],
                "duration_days": 5,
                "budget_vnd": 10000000,
                "interests": ["beach", "culture"]
            }
        )
        return response.json()
```

### **2. Quản lý dữ liệu du lịch:**
```python
# Thêm điểm đến mới
async def add_destination():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "http://localhost:8000/api/v1/data/insert",
            json={
                "item_type": "destination",
                "data": {
                    "name": "Phong Nha",
                    "region": "Central",
                    "description": "Famous for caves and karst landscape"
                }
            }
        )
        return response.json()
```

---

## 🔧 **Development**

### **Cài đặt development dependencies:**
```bash
pip install -e ".[dev]"
```

### **Code formatting:**
```bash
black app/
isort app/
```

### **Type checking:**
```bash
mypy app/
```

### **Testing:**
```bash
pytest tests/ -v
```

### **Pre-commit hooks:**
```bash
pre-commit install
pre-commit run --all-files
```

---

## 🐳 **Docker Deployment**

### **📋 Prerequisites**

- [Docker](https://docs.docker.com/get-docker/) (20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (2.0+)

### **🚀 Quick Start with Docker**

#### **1. Build the Docker image**
```bash
docker build -t vivuvn-ai-service:latest .
```

**Build time:** ~8-12 minutes (first build), ~1-2 minutes (cached builds)

#### **2. Configure environment**
```bash
# Copy the Docker environment template
cp .env.docker .env.docker.local

# Edit with your API keys
notepad .env.docker.local  # Windows
nano .env.docker.local     # Linux/macOS
```

**Required settings:**
- `GEMINI_API_KEY` - Your Google Gemini API key
- `PINECONE_API_KEY` - Your Pinecone API key
- `ALLOWED_ORIGINS` - Your frontend URLs

#### **3. Run with Docker Compose (Recommended)**
```bash
# Update docker-compose.yml to use your env file
# Change env_file to .env.docker.local

# Start the service
docker-compose up -d

# View logs
docker-compose logs -f

# Check health
curl http://localhost:8000/health
```

#### **4. Run with Docker directly**
```bash
docker run -d \
  --name vivuvn-ai-service \
  -p 8000:8000 \
  --env-file .env.docker.local \
  --restart unless-stopped \
  vivuvn-ai-service:latest
```

### **🔍 Docker Container Management**

```bash
# View logs
docker logs -f vivuvn-ai-service

# Stop service
docker-compose down
# or
docker stop vivuvn-ai-service

# Restart service
docker-compose restart
# or
docker restart vivuvn-ai-service

# Remove container
docker rm vivuvn-ai-service

# Remove image
docker rmi vivuvn-ai-service:latest
```

### **📊 Docker Image Details**

**Image Characteristics:**
- **Base Image:** Python 3.11 Slim (Debian Bookworm)
- **Size:** ~2.5-3GB (includes ML models)
- **Build Type:** Multi-stage (optimized)
- **Security:** Runs as non-root user `vivuapp`
- **Pre-downloaded:** Vietnamese embedding model included

**Performance Metrics:**
- **Startup Time:** 10-30 seconds
- **Memory Usage:** ~1.5-2GB RAM (for ML models)
- **CPU:** Recommended 2+ cores
- **Health Check:** Built-in `/health` endpoint

### **🔧 Advanced Docker Configuration**

#### **Volume Mounts for Development**
```yaml
# Add to docker-compose.yml volumes section:
volumes:
  - ./app:/app/app:ro          # Hot reload code changes
  - ./data:/app/data:ro        # Mount data directory
  - ./logs:/app/logs           # Persist logs
```

#### **Resource Limits**
```yaml
# Already configured in docker-compose.yml:
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 3G
    reservations:
      cpus: '0.5'
      memory: 1G
```

#### **Custom Port Mapping**
```bash
# Use a different host port
docker run -p 9000:8000 --env-file .env.docker.local vivuvn-ai-service:latest

# Access at: http://localhost:9000
```

### **🌐 Production Deployment**

#### **Using Docker Swarm**
```bash
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.yml vivuvn-stack

# Scale service
docker service scale vivuvn-stack_vivuvn-ai-service=3
```

#### **Using Kubernetes**
```bash
# Build and tag for registry
docker build -t your-registry.com/vivuvn-ai-service:v1.0.0 .
docker push your-registry.com/vivuvn-ai-service:v1.0.0

# Create secrets
kubectl create secret generic vivuvn-secrets \
  --from-literal=GEMINI_API_KEY=your_key \
  --from-literal=PINECONE_API_KEY=your_key

# Deploy (create k8s manifests based on docker-compose.yml)
kubectl apply -f k8s-deployment.yml
```

#### **Environment Variables for Production**
```bash
# .env.docker.production
DEBUG=False
LOG_LEVEL=INFO
PINECONE_INDEX_NAME=vivuvn-travel-prod
ALLOWED_ORIGINS=["https://vivuvn.com", "https://app.vivuvn.com"]
```

### **🐛 Docker Troubleshooting**

#### **Container won't start**
```bash
# Check logs for errors
docker logs vivuvn-ai-service

# Common issues:
# 1. Missing API keys in .env.docker
# 2. Port 8000 already in use
# 3. Insufficient memory (need 2GB+)
```

#### **Health check failing**
```bash
# Check health endpoint manually
docker exec vivuvn-ai-service curl -f http://localhost:8000/health

# Check if port is accessible
curl http://localhost:8000/health
```

#### **Image too large**
```bash
# The image is ~2.5-3GB due to ML models (unavoidable)
# This is normal for ML services

# View image layers
docker history vivuvn-ai-service:latest

# Clean up unused images
docker system prune -a
```

#### **Slow startup**
```bash
# If startup is slow, check:
# 1. Model is pre-downloaded in image (should be)
# 2. Sufficient memory allocated
# 3. Network connectivity for API validation

# View startup logs
docker logs -f vivuvn-ai-service
```

---

## 🚀 **Traditional Deployment (Non-Docker)**

### **Production Setup:**
```bash
# Set production environment
export DEBUG=false
export LOG_LEVEL=INFO

# Run with gunicorn
pip install gunicorn
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000
```

### **Environment Variables for Production:**
```bash
DEBUG=false
LOG_LEVEL=INFO
PINECONE_INDEX_NAME=vivuvn-travel-prod
```

---

## 🛠️ **Troubleshooting**

### **Lỗi import dependencies:**
```bash
pip install --upgrade pip
pip install --force-reinstall -r requirements.txt
```

### **Lỗi Pinecone connection:**
```bash
# Kiểm tra API key và region
python -c "
from app.core.config import settings
print(f'API Key configured: {bool(settings.PINECONE_API_KEY)}')
print(f'Region: {settings.PINECONE_REGION}')
"
```

### **Lỗi Google Gemini API:**
```bash
# Kiểm tra API key
python -c "
from app.core.config import settings
print(f'Gemini API configured: {bool(settings.GEMINI_API_KEY)}')
"
```

### **Clear pip cache:**
```bash
pip cache purge
pip install --no-cache-dir -r requirements.txt
```

---

## 🤝 **Contributing**

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🎉 **Credits**

- **FastAPI**: Modern Python web framework
- **Pinecone**: Vector database for semantic search
- **Google Gemini**: Advanced language model
- **LangChain**: AI application framework
- **Sentence Transformers**: Embedding models

---

## 📞 **Support**

- 📧 **Email**: support@vivuvn.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/vivuvn/vivuvn_ai_service/issues)
- 📖 **Documentation**: [API Docs](http://localhost:8000/docs)

---

<div align="center">

**Made with ❤️ in Vietnam**

*Tạo lịch trình du lịch Việt Nam thông minh với AI*

</div>