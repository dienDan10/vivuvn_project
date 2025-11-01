# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ViVu Vietnam AI Service** is a standalone AI-powered travel itinerary generator specifically designed for Vietnam destinations. It uses FastAPI, Google Gemini (via LangChain/LangGraph), and Pinecone Serverless vector database.

**Key Architecture Principle**: This is a **standalone AI service** with NO local database. It only uses:
- Pinecone Serverless for vector storage (places/destinations)
- Google Gemini API for AI generation
- The external MySQL database is managed by a separate web service

## Common Commands

### Development

```bash
# Install dependencies (uses fastapi[standard] which includes uvicorn, pydantic, httpx)
pip install -r requirements.txt

# Run the service (recommended - uses settings from .env with hot reload)
python -m app.main

# Alternative: Run with custom uvicorn settings
uvicorn app.main:app --reload --host localhost --port 5278

# Install with dev dependencies
pip install -e ".[dev]"
```

**Note**: When running via `python -m app.main`:
- Uses `HOST` and `PORT` from `.env` file (default: localhost:5278)
- Hot reload is always enabled
- Structured logging configured automatically

### Code Quality

```bash
# Format code
black app/
isort app/

# Type checking
mypy app/
```

### Testing

Note: Tests are defined in [pyproject.toml](pyproject.toml#L127) but pytest is not currently installed in the environment.

```bash
# Install test dependencies first
pip install pytest pytest-asyncio

# Run all tests
pytest tests/ -v

# Run specific test markers
pytest -m "not slow"  # Skip slow tests
pytest -m integration  # Only integration tests
pytest -m pinecone    # Only Pinecone-dependent tests
pytest -m ai          # Only AI service tests
```

### Data Loading

```bash
# Load location data from data/location_data.json into Pinecone
python load_location_data.py
```

This script uses the optimized chunking approach with Vietnamese embeddings to populate the Pinecone vector database.

### Health Checks

```bash
# Check service health
curl http://localhost:8000/health

# Debug endpoints (only available when DEBUG=true)
curl http://localhost:8000/debug/config
curl http://localhost:8000/debug/services
```

## High-Level Architecture

### Core Services Architecture

The application follows a **modular agent architecture** with single responsibility principle:

```
API Layer (FastAPI routes)
    ↓
Agent Orchestration (TravelPlanningAgent)
    ↓
Specialized Agents (Search, Weather, Itinerary, Validation, Response)
    ↓
Service Layer (Vector, Embedding, Weather)
    ↓
External Services (Pinecone, Gemini, OpenWeather)
```

**Critical Services**:

1. **VectorService** ([app/services/vector_service.py](app/services/vector_service.py)): Low-level Pinecone operations (search, upsert, delete, index management)

2. **EmbeddingService** ([app/services/embedding_service.py](app/services/embedding_service.py)): Generates embeddings using Google's embedding API (`gemini-embedding-001`, 768 dimensions). Handles text preprocessing and task-specific embedding generation.

3. **WeatherService** ([app/services/weather_service.py](app/services/weather_service.py)): OpenWeather API integration for daily weather forecasts with proper error handling.

4. **Modular Agents** ([app/agents/](app/agents/)): Specialized agents for different aspects of travel planning:
   - **SearchAgent**: Place discovery, filtering, and geo-clustering
   - **WeatherAgent**: Weather data fetching and coordination extraction
   - **ItineraryAgent**: LLM-based itinerary generation with Gemini
   - **ValidationAgent**: Anti-hallucination checks and place_id validation
   - **ResponseAgent**: Final response building and data conversion
   - **TravelPlanningAgent**: Main orchestrator coordinating all agents

### Embedding & Search Strategy

**Google Embedding API Integration**:

- **Embedding Model**: `gemini-embedding-001` (768 dimensions)
- **Task Types**: 
  - `RETRIEVAL_DOCUMENT` for indexing place data
  - `RETRIEVAL_QUERY` for user search queries
- **Benefits**: Better search quality, no local model hosting, automatic updates

**Metadata Strategy**:
- **Pinecone stores**: Essential metadata (place_id, name, rating, province, latitude, longitude, description)
- **Benefits**: Efficient search, complete data in vector store

**Geographic Clustering**:
- Places are clustered using K-means on lat/lng coordinates
- Optimizes route planning and reduces travel distance
- Auto-determines cluster count based on trip duration

### LangGraph Workflow (Travel Planning)

The travel planning uses a **6-node LangGraph workflow** with modular agents and anti-hallucination validation:

**Workflow Nodes:**

1. **build_filters** (SearchAgent) → Build search filters (province, normalized location)
2. **search_places** (SearchAgent) → Query Pinecone with dynamic top_k, geo-clustering
3. **fetch_weather_data** (WeatherAgent) → Fetch weather forecast from OpenWeather API
4. **generate_structured_itinerary** (ItineraryAgent) → Call Gemini with structured output + system instruction
5. **validate_output** (ValidationAgent) → Anti-hallucination: verify all activities have valid place_id
6. **finalize_response** (ResponseAgent) → Build final TravelResponse with itinerary + weather

**State Management:**
- All nodes share `TravelPlanningState` TypedDict
- State flows: request → filters → places → weather → itinerary → validation → response

**Anti-Hallucination Measures**:
- **Modular prompts**: System prompt adapts based on preferences/requirements
- **Grounded data**: User prompt includes ONLY places from vector search
- **place_id requirement**: Every activity MUST have a valid place_id from database
- **Validation layer**: Checks place_id exists and names match (fuzzy)
- **Structured output**: Uses Gemini's response_schema for type-safe JSON

**Agent Benefits**:
- **Single Responsibility**: Each agent has one clear purpose
- **Testability**: Test agents independently with mocks
- **Maintainability**: ~100-120 lines per agent vs 600+ monolithic
- **Scalability**: Easy to add new agents (caching, personalization, etc.)

### Configuration

All settings in [app/core/config.py](app/core/config.py) use Pydantic Settings loaded from `.env`:

**Critical Environment Variables**:
- `GEMINI_API_KEY` - Google Gemini API key (required)
- `PINECONE_API_KEY` - Pinecone API key (required)
- `PINECONE_INDEX_NAME` - Index name (default: vivuvn-travel)
- `PINECONE_CLOUD` - Cloud provider (aws/gcp/azure)
- `PINECONE_REGION` - Serverless region (e.g., us-east-1)
- `OPENWEATHER_API_KEY` - OpenWeather API key for weather forecasts
- `EMBEDDING_MODEL` - Google embedding model (default: gemini-embedding-001)
- `EMBEDDING_DIMENSION` - 768 for gemini-embedding-001
- `GEMINI_MODEL` - Default: gemini-2.0-flash-exp

### API Structure

**Main Routes**:
- `/api/v1/travel/*` - Travel planning endpoints ([app/api/routes/travel_planner.py](app/api/routes/travel_planner.py))
- `/api/v1/data/*` - Data management endpoints ([app/api/routes/data_management.py](app/api/routes/data_management.py))

**Key Endpoints**:
- `POST /api/v1/travel/generate-itinerary` - Generate itinerary (uses TravelPlanningAgent)
- `POST /api/v1/data/insert` - Insert single place
- `POST /api/v1/data/batch-upload` - Batch upload places
- `GET /api/v1/data/stats` - Get Pinecone index statistics

**Request/Response Models**: Defined in [app/api/schemas.py](app/api/schemas.py) using Pydantic v2.

## Important Implementation Details

### Google Gemini Integration

Uses the **modern `google-genai` v1.38.0 SDK** (not the deprecated `google-generativeai`):

```python
from google import genai
from google.genai import types

client = genai.Client(api_key=settings.GEMINI_API_KEY)

# Config created per-request to include system instruction
request_config = types.GenerateContentConfig(
    system_instruction=system_prompt,  # Adaptive based on request
    response_mime_type="application/json",
    response_schema=TravelItinerary,  # Pydantic model for structured output
    thinking_config=types.ThinkingConfig(thinking_budget=0),
    temperature=settings.TEMPERATURE,
    max_output_tokens=settings.MAX_TOKENS
)

response = client.models.generate_content(
    model=settings.GEMINI_MODEL,
    config=request_config,
    contents=user_prompt
)

# Access parsed Pydantic object directly
itinerary: TravelItinerary = response.parsed
```

**Key Features**:
- **Structured Output**: Uses `response_schema` with Pydantic models for type-safe JSON
- **System Instruction**: Added to GenerateContentConfig (not as separate parameter)
- **Adaptive Prompts**: System prompt changes based on preferences/requirements
- **Thinking Budget**: Set to 0 for faster responses

### Pinecone v6+ Integration

Uses **Pinecone v6.0.1 with gRPC** for better performance:

```python
from pinecone.grpc import PineconeGRPC

pc = PineconeGRPC(api_key=api_key)
index = pc.Index(index_name, pool_threads=50)
```

**Serverless Index Creation**:
```python
from pinecone import ServerlessSpec

pc.create_index(
    name=index_name,
    dimension=768,
    metric="cosine",
    spec=ServerlessSpec(cloud="aws", region="us-east-1")
)
```

### Google Embedding API

Uses **Google's `gemini-embedding-001` model** via the genai SDK:

```python
from google import genai

client = genai.Client(api_key=settings.GEMINI_API_KEY)

# Task-specific embeddings
embedding = client.models.embed_content(
    model="gemini-embedding-001",
    content=text,
    config=types.EmbedContentConfig(
        task_type="RETRIEVAL_DOCUMENT"  # or "RETRIEVAL_QUERY"
    )
)

vector = embedding.embeddings[0].values  # 768-dimensional vector
```

**Task Types**:
- `RETRIEVAL_DOCUMENT`: For indexing place data in Pinecone
- `RETRIEVAL_QUERY`: For user search queries

**Benefits**:
- Better multilingual support (Vietnamese + English)
- No local model hosting required
- Automatic model updates from Google
- Consistent 768-dimensional vectors

### Modular Agent Architecture

The travel planning system uses a **modular agent architecture** following the Single Responsibility Principle. Each agent is a separate class in [app/agents/](app/agents/):

**Agent Directory Structure**:
```
app/agents/
├── state.py                      # TravelPlanningState TypedDict
├── search_agent.py               # SearchAgent (~180 lines)
├── weather_agent.py              # WeatherAgent (~90 lines)
├── itinerary_agent.py            # ItineraryAgent (~120 lines)
├── validation_agent.py           # ValidationAgent (~100 lines)
├── response_agent.py             # ResponseAgent (~110 lines)
└── travel_planning_agent.py      # TravelPlanningAgent (~120 lines)
```

**Agent Responsibilities**:

1. **SearchAgent** - Place discovery and filtering
   - Builds search filters (province normalization)
   - Calculates dynamic top_k based on trip duration
   - Executes vector search with Pinecone
   - Performs geographic clustering (K-means)

2. **WeatherAgent** - Weather data integration
   - Fetches weather forecasts from OpenWeather API
   - Extracts coordinates from place data
   - Handles weather API failures gracefully

3. **ItineraryAgent** - LLM-based generation
   - Builds adaptive prompts (system + user)
   - Calls Gemini API with structured output
   - Manages Gemini client configuration
   - Converts response to structured format

4. **ValidationAgent** - Anti-hallucination checks
   - Validates every activity has valid place_id
   - Checks place_id against database
   - Fuzzy name matching for verification
   - Logs validation warnings/errors

5. **ResponseAgent** - Response building
   - Converts structured data to Pydantic models
   - Builds final TravelResponse
   - Attaches weather forecast
   - Handles conversion errors

6. **TravelPlanningAgent** - Main orchestrator
   - Initializes all specialized agents
   - Builds LangGraph workflow
   - Coordinates execution flow
   - Error handling and logging

**Benefits**:
- **Maintainability**: ~100-120 lines per agent vs 600+ monolithic
- **Testability**: Test each agent independently
- **Scalability**: Add new agents without touching existing code
- **Clarity**: Self-documenting structure, clear data flow

**Usage**:
```python
from app.agents import get_travel_agent

agent = get_travel_agent()  # Singleton instance
response = await agent.plan_travel(travel_request)
```

### Error Handling

Custom exceptions in [app/core/exceptions.py](app/core/exceptions.py):
- `VivuVNBaseException` - Base exception
- `TravelPlanningError` - Travel planning failures
- `ItineraryGenerationError` - AI generation failures
- Includes error codes and HTTP status code mapping

### Logging

All modules use **structlog** for consistent, structured logging:

```python
import structlog

logger = structlog.get_logger(__name__)
logger.info("Processing request", user_id=123, action="search")
```

**Key points**:
- **Never use** standard `logging` module - always use `structlog`
- Console renderer for human-readable output in development
- ISO timestamps and log levels included automatically
- Configuration in [app/main.py](app/main.py#L29)

**Modern imports**:
- ✅ `from langchain_text_splitters import RecursiveCharacterTextSplitter` (correct)
- ❌ `from langchain.text_splitter import RecursiveCharacterTextSplitter` (deprecated)

## Working with This Codebase

### Adding New AI Features

When adding AI generation features:
1. Use the modern `google-genai` SDK, not deprecated packages
2. Define Pydantic models for structured output in [app/models/](app/models/)
3. Use `response_schema` parameter for guaranteed JSON structure
4. Implement anti-hallucination measures (grounding, validation)
5. Add proper error handling with custom exceptions
6. **Consider creating a new agent** if adding significant functionality

### Adding a New Agent

To add a new specialized agent:

1. **Create agent file** in `app/agents/`:
```python
# app/agents/your_agent.py
import structlog
from app.agents.state import TravelPlanningState

logger = structlog.get_logger(__name__)

class YourAgent:
    """Agent responsible for [specific task]."""
    
    def __init__(self):
        """Initialize your agent."""
        # Initialize dependencies
        pass
    
    async def your_method(self, state: TravelPlanningState) -> TravelPlanningState:
        """Node X: [Description]."""
        try:
            # Your logic here
            state["your_data"] = result
            return state
        except Exception as e:
            logger.error(f"[Node X] Failed: {e}")
            state["error"] = f"Your task failed: {str(e)}"
            return state
```

2. **Update state.py** if needed:
```python
# Add new fields to TravelPlanningState
class TravelPlanningState(TypedDict):
    # ... existing fields ...
    your_data: Optional[YourDataType]
```

3. **Wire into workflow** in `travel_planning_agent.py`:
```python
from app.agents.your_agent import YourAgent

class TravelPlanningAgent:
    def __init__(self):
        # ... existing agents ...
        self.your_agent = YourAgent()
    
    def _build_workflow(self):
        workflow.add_node("your_node", self.your_agent.your_method)
        workflow.add_edge("previous_node", "your_node")
        workflow.add_edge("your_node", "next_node")
```

4. **Add tests** for your agent independently

### Modifying Vector Search

When changing vector search:
1. Minimal metadata only in Pinecone (see [embedding_service.py](app/services/embedding_service.py#L242))
2. Keep chunk_text snippets under 300 chars
3. Always include place_id for data fetching
4. Use filters efficiently (province, rating, place_ids)

### Dependencies

**requirements.txt uses `fastapi[standard]`**:
- Includes: FastAPI, Uvicorn, Pydantic, httpx, python-multipart
- Simpler and prevents version conflicts
- All production-ready dependencies included

When adding dependencies:
- Use specific versions (e.g., `package==1.2.3`)
- Add comments explaining what each package does
- Keep organized by category

### Environment Variables

Always update both:
- `.env` file for local development
- [.env.example](.env.example) as template for others

### Data Loading

The [load_location_data.py](load_location_data.py) script expects `data/location_data.json` with this structure:

```json
{
  "provinces": [
    {
      "province": "Province Name",
      "places": [
        {
          "name": "Place Name",
          "googlePlaceId": "ChIJ...",
          "description": "...",
          "address": "...",
          "latitude": 10.123,
          "longitude": 106.456,
          "rating": 4.5
        }
      ]
    }
  ]
}
```

### API Documentation

When server is running with `DEBUG=true`:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- OpenAPI JSON: http://localhost:8000/openapi.json

These are disabled in production mode for security.

## Key Files to Check

When debugging or modifying the system, these are the key files:

### Configuration & Setup
- [app/core/config.py](app/core/config.py) - All environment variables and settings
- [.env](..env) - Environment configuration (not in repo)
- [requirements.txt](requirements.txt) - Python dependencies
- [Dockerfile](Dockerfile) - Docker build configuration

### Agent System (Modular Architecture)
- [app/agents/travel_planning_agent.py](app/agents/travel_planning_agent.py) - Main orchestrator
- [app/agents/search_agent.py](app/agents/search_agent.py) - Place search & clustering
- [app/agents/weather_agent.py](app/agents/weather_agent.py) - Weather integration
- [app/agents/itinerary_agent.py](app/agents/itinerary_agent.py) - Gemini LLM generation
- [app/agents/validation_agent.py](app/agents/validation_agent.py) - Anti-hallucination
- [app/agents/response_agent.py](app/agents/response_agent.py) - Response building
- [app/agents/state.py](app/agents/state.py) - Workflow state definition

### Core Services
- [app/services/vector_service.py](app/services/vector_service.py) - Pinecone operations
- [app/services/embedding_service.py](app/services/embedding_service.py) - Google Embeddings
- [app/services/weather_service.py](app/services/weather_service.py) - Weather processing

### API Layer
- [app/api/routes/travel_planner.py](app/api/routes/travel_planner.py) - Travel endpoints
- [app/api/schemas.py](app/api/schemas.py) - Request/Response models
- [app/main.py](app/main.py) - FastAPI application entry point

### Data Models & Prompts
- [app/models/travel_models.py](app/models/travel_models.py) - Travel itinerary models
- [app/models/weather_models.py](app/models/weather_models.py) - Weather data models
- [app/prompts/travel_prompts.py](app/prompts/travel_prompts.py) - Modular prompt system

### Utilities
- [app/utils/geo_utils.py](app/utils/geo_utils.py) - Geographic clustering (K-means)
- [app/utils/helpers.py](app/utils/helpers.py) - Province normalization, etc.
- [load_location_data.py](load_location_data.py) - Data loading script
