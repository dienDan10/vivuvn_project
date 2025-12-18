# ViVuVN - Collaborative Travel Planning Platform

<div align="center">

**A comprehensive travel planning solution designed for the Vietnamese market**

*Capstone Project - Group SEP490-G109*

Supervisor: **Chu Thi Minh Hue**

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [API Documentation](#api-documentation)

---

## 🌟 Overview

ViVuVN is a collaborative travel planning platform specifically designed for the Vietnamese market. The platform addresses the limitations of existing solutions by offering comprehensive group collaboration features, intelligent itinerary generation powered by AI, and seamless budget management for group travel.

### Mission

Making group travel planning simple, collaborative, and enjoyable for Vietnamese travelers through technology-driven solutions that combine real-time collaboration, AI-powered recommendations, and comprehensive budget tracking.

### Differentiation

Unlike traditional travel planning tools, ViVuVN focuses on:
- **True Collaboration**: Real-time chat, group decision-making, and role-based member management
- **AI-Powered Planning**: Intelligent itinerary generation using RAG patterns with Gemini LLM and vector search
- **Comprehensive Budget Tracking**: Multi-member expense management with statistical insights
- **Instant Sharing**: QR code-based invitation system for quick group formation
- **Vietnamese-Centric**: Designed specifically for Vietnamese locations, culture, and travel patterns

---

## ✨ Key Features

### 🤝 Collaborative Planning

**Group Management**
- Role-based member permissions (Owner, Editor, Viewer)
- QR code invitation system for instant group joining
- Member kick/leave functionality
- Real-time notification system for group announcements

**Real-Time Communication**
- Polling-based chat system optimized for mobile
- Message history with pagination
- Chat updates with last-read tracking
- Push notifications via Firebase Cloud Messaging

### 🗺️ Itinerary Management

**Schedule Planning**
- Multi-day itinerary creation and management
- Location-based activity scheduling with time slots
- Transportation route planning between locations
- Restaurant and hotel integration into itineraries
- Favorite places collection for quick access

**AI-Powered Generation**
- Automatic itinerary generation based on:
  - Destination preferences
  - Budget constraints
  - Number of days and travelers
  - Activity preferences
- Semantic location search using vector databases
- Cost estimation and optimization
- Transportation mode suggestions

### 💰 Budget Management

**Expense Tracking**
- Multi-member expense recording
- Budget type categorization (Food, Transportation, Accommodation, Activities, Shopping, Others)
- Payer tracking and cost splitting
- Currency support (VND/USD with fixed exchange rate)
- Estimated vs actual budget comparison

**Analytics & Insights**
- Budget type distribution statistics
- Member spending analysis
- Budget utilization percentage
- Total expense tracking across all categories

### 📱 Location & Discovery

**Location Database**
- Comprehensive Vietnamese location catalog
- Province-based location search
- Location details with photos, ratings, and reviews
- Restaurant and hotel recommendations by location
- Google Maps integration for directions and routes

**Search & Filter**
- Text-based location search
- Province and location filtering
- Sort by rating, popularity, and relevance
- Suggested locations based on itinerary province

### 🔐 Authentication & User Management

**Authentication**
- Google OAuth integration for secure sign-in
- Email/password authentication with verification
- JWT-based token authentication
- Password reset via email
- Refresh token mechanism

**User Profiles**
- Avatar customization with Firebase Storage
- Username and phone number management
- User device registration for push notifications
- Notification preferences and history

### 📊 Admin & Analytics

**Admin Dashboard**
- System overview statistics (travelers, locations, provinces, itineraries)
- Top provinces by visit count
- Top locations by popularity
- Itinerary creation trends over time

**Content Management**
- Province CRUD operations with image upload
- Location CRUD operations with image upload
- User account management (lock/unlock)
- Operator account creation

---

## 🏗 System Architecture

### High-Level Architecture

```
┌──────────────────────┐
│   Flutter Mobile App  │
│   (Android/iOS)       │
└──────────┬───────────┘
           │
           │ HTTP/REST
           │
┌──────────▼───────────┐     ┌─────────────────┐
│  ASP.NET Core 8.0    │────▶│  SQL Server     │
│  Backend API         │     │  Database       │
└──────────┬───────────┘     └─────────────────┘
           │
           │
    ┌──────┴──────┬──────────────┬─────────────┐
    │             │              │             │
┌───▼────┐  ┌────▼─────┐  ┌─────▼──────┐  ┌──▼─────────┐
│Firebase│  │  Google  │  │   Brevo    │  │  AI Service│
│Storage │  │  Cloud   │  │   Email    │  │  (Python)  │
│ + FCM  │  │  OAuth   │  │  Service   │  └────┬───────┘
└────────┘  │  + Maps  │  └────────────┘       │
            └──────────┘                  ┌─────┴──────┐
                                          │  Pinecone  │
                                          │  VectorDB  │
                                          └────────────┘
                                          ┌────────────┐
                                          │   Gemini   │
                                          │    LLM     │
                                          └────────────┘
```

### Backend Architecture

**Clean Architecture Layers**
1. **API Layer** (`Controllers`): HTTP request handling, routing, authorization
2. **Service Layer** (`Services`): Business logic, validation, orchestration
3. **Repository Layer** (`Repositories`): Data access abstraction, CRUD operations
4. **Data Layer** (`Models`, `Data`): Entity Framework Core, SQL Server

**Key Design Patterns**
- Repository Pattern with Generic Base Repository
- Unit of Work for transaction management
- Dependency Injection for loose coupling
- AutoMapper for object-to-object mapping
- JWT Bearer Authentication with role-based authorization

---

## 🛠 Technology Stack

### Mobile Application (vivuvn_app)
- **Framework**: Flutter 3.35+ (Dart 3.9+)
- **State Management**: Riverpod (AutoDisposeNotifierProvider pattern)
- **Architecture**: Clean Architecture
  - API Layer: Dio HTTP client
  - Service Layer: Business logic separation
  - Controller Layer: State management with Riverpod
  - UI Layer: Widget composition
- **Storage**: Firebase Storage for images
- **Notifications**: Firebase Cloud Messaging (FCM)
- **Local Storage**: Flutter Secure Storage for tokens
- **Image Handling**: cached_network_image, image_picker
- **QR Code**: zxing2 for QR generation and scanning
- **Maps**: Google Maps Flutter integration

### Backend API (vivuvn_api)
- **Framework**: ASP.NET Core 8.0 (C#)
- **Database**: SQL Server with Entity Framework Core 8.0
- **Authentication**: 
  - JWT Bearer Tokens (System.IdentityModel.Tokens.Jwt)
  - Google OAuth (Google.Apis.Auth)
  - Password hashing (ASP.NET Core Identity)
- **Object Mapping**: AutoMapper 14.0
- **API Documentation**: Swashbuckle (Swagger/OpenAPI)
- **Cloud Services**:
  - Firebase Admin SDK for FCM and Storage
  - Google.Cloud.Storage.V1 for file management
- **Email**: Brevo API (sib_api_v3_sdk) for transactional emails
- **Query Optimization**: LinqKit for dynamic expressions

### AI Service
- **Language**: Python
- **Architecture**: Microservices with RAG pattern
- **Vector Database**: Pinecone for semantic search
- **LLM**: Google Gemini for itinerary generation
- **Integration**: REST API consumed by ASP.NET Core backend

### Admin Web Client (vivuvn_web_client)
- **Framework**: React
- **HTTP Client**: Axios with custom configuration
- **Purpose**: Admin and operator management interface
- **Features**: Province/Location CRUD, User management, Analytics dashboard

### Third-Party Services
- **Firebase**: Storage (images/files) + Cloud Messaging (push notifications)
- **Google Cloud**: OAuth 2.0 authentication + Maps API (routes/places)
- **Brevo**: Transactional email service (verification, password reset, notifications)
- **Pinecone**: Vector database for semantic location search

---

## 📚 API Documentation

Base URL: `https://api.vivuvn.com/api/v1` (Production) or `http://localhost:5277/api/v1` (Development)

### Authentication Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/login` | Email/password login | No |
| POST | `/auth/register` | Create new account | No |
| POST | `/auth/google-login` | Google OAuth login | No |
| POST | `/auth/verify-email` | Verify email with token | No |
| POST | `/auth/resend-verification` | Resend verification email | No |
| POST | `/auth/refresh-token` | Refresh access token | No |
| POST | `/auth/change-password` | Change password | Yes |
| POST | `/auth/forgot-password` | Request password reset | No |
| POST | `/auth/reset-password` | Reset password with token | No |

### User Management Endpoints

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| GET | `/users/me` | Get current user profile | Yes | All |
| GET | `/users` | Get all users (paginated) | Yes | Admin |
| PUT | `/users/{userId}/avatar` | Update user avatar | Yes | Owner |
| PUT | `/users/{userId}/username` | Update username | Yes | Owner |
| PUT | `/users/{userId}/phone-number` | Update phone number | Yes | Owner |
| PUT | `/users/{userId}/lock` | Lock user account | Yes | Admin |
| PUT | `/users/{userId}/unlock` | Unlock user account | Yes | Admin |
| POST | `/users/operator` | Create operator account | Yes | Admin |
| POST | `/users/devices` | Register FCM device token | Yes | All |
| DELETE | `/users/devices/{fcmToken}` | Deactivate device token | Yes | All |

### Itinerary Management Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries` | Get all user itineraries | Yes |
| GET | `/itineraries/{id}` | Get itinerary details | Yes |
| POST | `/itineraries` | Create new itinerary | Yes |
| DELETE | `/itineraries/{id}` | Delete itinerary | Yes (Owner) |
| PUT | `/itineraries/{id}/dates` | Update itinerary dates | Yes (Owner) |
| PUT | `/itineraries/{id}/name` | Update itinerary name | Yes (Owner) |
| PUT | `/itineraries/{id}/images` | Update itinerary cover image | Yes (Owner) |
| PUT | `/itineraries/{id}/visibility` | Update visibility status | Yes (Owner) |
| POST | `/itineraries/{id}/invite` | Generate invitation code | Yes (Owner) |
| POST | `/itineraries/join` | Join itinerary via code | Yes |

### Schedule Management Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries/{id}/days` | Get itinerary schedule | Yes |
| POST | `/itineraries/{id}/days/auto-generate` | AI-generate itinerary | Yes (Owner) |
| GET | `/itineraries/{id}/days/{dayId}/items` | Get day schedule items | Yes |
| POST | `/itineraries/{id}/days/{dayId}/items` | Add item to day | Yes |
| PUT | `/itineraries/{id}/days/{dayId}/items/{itemId}` | Update schedule item | Yes |
| PUT | `/itineraries/{id}/days/{dayId}/items/{itemId}/routes` | Update transportation route | Yes |
| DELETE | `/itineraries/{id}/days/{dayId}/items/{itemId}` | Remove item from day | Yes |

### Budget Management Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries/{id}/budget` | Get budget details | Yes |
| PUT | `/itineraries/{id}/budget` | Update estimated budget | Yes (Owner) |
| GET | `/itineraries/{id}/budget/budget-types` | Get available budget types | Yes |
| POST | `/itineraries/{id}/budget/items` | Add budget item | Yes |
| PUT | `/itineraries/{id}/budget/items/{itemId}` | Update budget item | Yes |
| DELETE | `/itineraries/{id}/budget/items/{itemId}` | Delete budget item | Yes |

### Member Management Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries/{id}/members` | Get itinerary members | Yes |
| POST | `/itineraries/{id}/members/leave` | Leave itinerary | Yes |
| DELETE | `/itineraries/{id}/members/{memberId}` | Kick member (owner only) | Yes (Owner) |

### Chat Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries/{id}/chat` | Get messages (paginated) | Yes |
| GET | `/itineraries/{id}/chat/new` | Poll for new messages | Yes |
| POST | `/itineraries/{id}/chat` | Send message | Yes |

### Favorite Places Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries/{id}/favorite-places` | Get favorite places | Yes |
| POST | `/itineraries/{id}/favorite-places` | Add favorite place | Yes |
| DELETE | `/itineraries/{id}/favorite-places/{locationId}` | Remove favorite place | Yes |

### Restaurant Management Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries/{id}/restaurants` | Get restaurants in itinerary | Yes |
| POST | `/itineraries/{id}/restaurants/suggestions` | Add from AI suggestions | Yes |
| POST | `/itineraries/{id}/restaurants/search` | Add from search | Yes |
| PUT | `/itineraries/{id}/restaurants/{restaurantId}/notes` | Update notes | Yes |
| PUT | `/itineraries/{id}/restaurants/{restaurantId}/dates` | Update date | Yes |
| PUT | `/itineraries/{id}/restaurants/{restaurantId}/times` | Update time | Yes |
| PUT | `/itineraries/{id}/restaurants/{restaurantId}/costs` | Update cost | Yes |
| DELETE | `/itineraries/{id}/restaurants/{restaurantId}` | Delete restaurant | Yes |

### Hotel Management Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/itineraries/{id}/hotels` | Get hotels in itinerary | Yes |
| POST | `/itineraries/{id}/hotels/suggestions` | Add from AI suggestions | Yes |
| POST | `/itineraries/{id}/hotels/search` | Add from search | Yes |
| PUT | `/itineraries/{id}/hotels/{hotelId}/notes` | Update notes | Yes |
| PUT | `/itineraries/{id}/hotels/{hotelId}/dates` | Update check-in/check-out | Yes |
| PUT | `/itineraries/{id}/hotels/{hotelId}/costs` | Update cost | Yes |
| DELETE | `/itineraries/{id}/hotels/{hotelId}` | Delete hotel | Yes |

### Location Endpoints

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| GET | `/locations` | Get locations (paginated, filtered) | Yes | All |
| GET | `/locations/{id}` | Get location details | No | - |
| GET | `/locations/{id}/restaurants` | Get restaurants by location | No | - |
| GET | `/locations/{id}/hotels` | Get hotels by location | No | - |
| GET | `/locations/search` | Search locations by name | No | - |
| GET | `/locations/restaurants/search` | Search restaurants by text | No | - |
| GET | `/locations/hotels/search` | Search hotels by text | No | - |
| POST | `/locations` | Create location | Yes | Admin/Operator |
| PUT | `/locations/{id}` | Update location | Yes | Admin/Operator |
| DELETE | `/locations/{id}` | Delete location | Yes | Admin/Operator |
| PUT | `/locations/{id}/restore` | Restore location | Yes | Admin/Operator |

### Province Endpoints

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| GET | `/provinces` | Get provinces (paginated) | Yes | Admin |
| GET | `/provinces/all` | Get all provinces (no pagination) | Yes | Admin/Operator |
| GET | `/provinces/{id}` | Get province details | No | - |
| GET | `/provinces/search` | Search provinces by name | No | - |
| POST | `/provinces` | Create province | Yes | Admin |
| PUT | `/provinces/{id}` | Update province | Yes | Admin |
| DELETE | `/provinces/{id}` | Delete province | Yes | Admin |
| PUT | `/provinces/{id}/restore` | Restore province | Yes | Admin |

### Notification Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/notifications` | Get user notifications | Yes |
| GET | `/notifications/unread/count` | Get unread count | Yes |
| PUT | `/notifications/{id}/read` | Mark as read | Yes |
| PUT | `/notifications/mark-all-read` | Mark all as read | Yes |
| DELETE | `/notifications/{id}` | Delete notification | Yes |
| POST | `/itineraries/{id}/notifications` | Send to all members (owner only) | Yes (Owner) |

### Analytics Endpoints (Admin/Operator)

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| GET | `/analytics/overview` | Get dashboard overview | Yes | Admin/Operator |
| GET | `/analytics/provinces/top` | Get top provinces | Yes | Admin/Operator |
| GET | `/analytics/locations/top` | Get top locations | Yes | Admin/Operator |
| GET | `/analytics/itineraries/trends` | Get itinerary trends | Yes | Admin/Operator |

### Common Query Parameters

**Pagination**
- `pageNumber` (default: 1)
- `pageSize` (default: 10)

**Sorting**
- `sortBy` (field name, e.g., "Name", "Rating", "CreatedAt")
- `isDescending` (true/false, default: false)

**Filtering** (varies by endpoint)
- `provinceId`: Filter by province
- `name`: Search by name
- `unreadOnly`: Filter unread notifications
- `startDate` / `endDate`: Date range filtering

### Response Format

**Success Response**
```json
{
  "data": { ... },
  "message": "Success message (optional)"
}
```

**Paginated Response**
```json
{
  "data": [ ... ],
  "pageNumber": 1,
  "pageSize": 10,
  "totalCount": 100,
  "totalPages": 10,
  "hasNextPage": true,
  "hasPreviousPage": false
}
```

**Error Response**
```json
{
  "message": "Error message",
  "errors": {
    "field": ["Validation error"]
  }
}
```

**Authentication**
- All authenticated endpoints require JWT Bearer token in Authorization header:
  ```
  Authorization: Bearer <access_token>
  ```

**Swagger Documentation**
- Full interactive API documentation available at `/swagger` when running the backend service

---

<div align="center">

**Built with ❤️ for travelers in Vietnam**

*ViVuVN - Making group travel planning simple and enjoyable*

**Capstone Project SEP490-G109** | Supervisor: Chu Thi Minh Hue

</div>
