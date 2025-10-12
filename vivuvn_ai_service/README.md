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

## 🚀 **Deployment**

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