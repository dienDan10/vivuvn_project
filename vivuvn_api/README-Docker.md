# VivuVN API - Docker Setup

This guide will help you run the VivuVN API with SQL Server using Docker containers.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)

## ?? Security First Setup

**?? IMPORTANT: Set up secure environment variables before running!**

### Step 1: Create Secure Environment File

**Windows:**
```bash
setup-secure-env.bat
```

**Linux/Mac:**
```bash
chmod +x setup-secure-env.sh
./setup-secure-env.sh
```

### Step 2: Configure Your API Keys

Edit the `.env` file and replace the placeholder values with your actual API keys:

```bash
# Edit the .env file
notepad .env      # Windows
nano .env         # Linux/Mac
```

**Required Configuration:**
- `BREVO_API_KEY` - Get from [Brevo Dashboard](https://app.brevo.com/settings/keys/api)
- `GOOGLE_MAPS_API_KEY` - Get from [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
- `GOOGLE_OAUTH_CLIENT_ID` - Get from Google OAuth setup
- `JWT_SECRET_KEY` - Use generated secure key (64+ characters)
- `SA_PASSWORD` - Strong password for SQL Server

### Step 3: Run Docker Setup

**Windows:**
```bash
docker-startup.bat
```

**Linux/Mac:**
```bash
chmod +x docker-startup.sh
./docker-startup.sh
```

## ?? Security Warnings

? **NEVER commit these to version control:**
- `.env` files
- `appsettings.*.local.json` files  
- Any files containing API keys or passwords

? **Always:**
- Use environment variables for secrets
- Add `.env` to your `.gitignore`
- Rotate API keys if exposed
- Use strong, unique passwords

## Quick Start (Legacy - Use Security Setup Above)

### Option 2: Manual Docker commands

1. **Build and start the containers:**
   ```bash
   docker-compose up --build -d
   ```

2. **Check container status:**
   ```bash
   docker-compose ps
   ```

## Services

The Docker setup includes two services:

### 1. VivuVN API (vivuvn-api)
- **Port:** 5277
- **URL:** http://localhost:5277
- **Environment:** Docker
- **Container Name:** vivuvn-api

### 2. SQL Server (sqlserver)
- **Port:** 1434 (avoiding conflict with local SQL Server on 1433)
- **Container Name:** vivuvn-sqlserver
- **Credentials:**
  - Username: `sa`
  - Password: Check your `.env` file
- **Database:** VivuVN (created automatically by Entity Framework)

## Configuration

### Environment-specific Settings
The API uses `appsettings.Docker.json` when running in Docker, which includes:
- Connection string pointing to the `sqlserver` container
- Updated JWT issuer/audience for Docker environment
- All other configurations preserved from your original setup

### Volumes
- **SQL Server Data:** Persisted in Docker volume `sqlserver_data`
- **Images Directory:** Mapped to `./images` on your host machine

## Useful Commands

### View Logs
```bash
# API logs
docker-compose logs -f vivuvn-api

# SQL Server logs
docker-compose logs -f sqlserver

# All logs
docker-compose logs -f
```

### Stop the Application
```bash
docker-compose down
```

### Restart Services
```bash
# Restart just the API
docker-compose restart vivuvn-api

# Restart all services
docker-compose restart
```

### Rebuild and Start
```bash
docker-compose up --build -d
```

## Database Migration

The application will automatically:
1. Create the database if it doesn't exist
2. Run Entity Framework migrations
3. Seed initial data (if configured)

## Sharing Your Application

### 1. Create a Docker Image
```bash
# Build the API image
docker build -t vivuvn-api:latest .
```

### 2. Save and Share the Image
```bash
# Save image to a tar file
docker save vivuvn-api:latest > vivuvn-api.tar

# Load image on another machine
docker load < vivuvn-api.tar
```

### 3. Push to Docker Registry (Optional)
```bash
# Tag for registry
docker tag vivuvn-api:latest your-registry/vivuvn-api:latest

# Push to registry
docker push your-registry/vivuvn-api:latest
```

### 4. Share the Complete Setup
Share these files with others:
- `docker-compose.yml`
- `Dockerfile`
- `docker-startup.sh` or `docker-startup.bat`
- `vivuvn_api/appsettings.Docker.json`
- `.dockerignore`

Others can then run:
```bash
docker-compose up -d
```

## Troubleshooting

### SQL Server Connection Issues
1. Wait 30-60 seconds after starting for SQL Server to fully initialize
2. Check SQL Server logs: `docker-compose logs sqlserver`
3. Verify the container is running: `docker-compose ps`

### API Not Starting
1. Check API logs: `docker-compose logs vivuvn-api`
2. Ensure SQL Server is ready before the API starts
3. Verify the connection string in `appsettings.Docker.json`

### Port Conflicts
If ports 5277 or 1434 are already in use, modify the ports in `docker-compose.yml`:
```yaml
ports:
  - "5278:80"  # Change 5277 to 5278 for API
  - "1435:1433"  # Change 1434 to 1435 for SQL Server
```

### Rebuild Everything
```bash
# Stop containers and remove volumes
docker-compose down -v

# Rebuild and start
docker-compose up --build -d
```

## Development Tips

- The `images` directory is mapped as a volume, so uploaded files persist
- Database data persists in the `sqlserver_data` volume
- Changes to code require rebuilding the Docker image
- Use `docker-compose logs -f vivuvn-api` to monitor API logs during development