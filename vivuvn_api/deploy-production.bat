@echo off
REM VivuVN Production Deployment Script
echo ==========================================
echo VivuVN Production Deployment
echo ==========================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ? Docker is not installed. Please install Docker first.
    pause
    exit /b 1
)

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ? Docker Compose is not installed. Please install Docker Compose first.
    pause
    exit /b 1
)

echo ? Docker and Docker Compose are installed

REM Check if production environment file exists
if not exist ".env.prod" (
    echo ? Production environment file (.env.prod) not found!
    echo Please create .env.prod from .env.prod.template with production values.
    pause
    exit /b 1
)

echo ? Production environment file found

REM Basic validation (Windows doesn't have grep, so we skip this check)
echo ??  Please ensure .env.prod has been updated with production values

REM Stop any existing containers
echo ?? Stopping existing containers...
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

REM Pull latest images
echo ?? Pulling latest base images...
docker pull mcr.microsoft.com/dotnet/sdk:8.0
docker pull mcr.microsoft.com/dotnet/aspnet:8.0
docker pull mcr.microsoft.com/mssql/server:2022-latest

REM Build and start production containers
echo ?? Building and starting production containers...
docker-compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod up --build -d

REM Wait for services to be ready
echo ? Waiting for services to be ready...
timeout /t 60 /nobreak >nul

REM Check container status
echo ?? Container Status:
docker-compose -f docker-compose.yml -f docker-compose.prod.yml ps

echo.
echo ==========================================
echo ?? Production Deployment Complete!
echo ==========================================
echo.
echo ?? Production Services:
echo    ?? API: http://localhost:5277
echo    ???  SQL Server: localhost:1434
echo    ?? Health Check: http://localhost:5277/health
echo.
echo ?? Production Commands:
echo    View logs:    docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f
echo    Stop:         docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
echo    Restart:      docker-compose -f docker-compose.yml -f docker-compose.prod.yml restart
echo.
echo ?? Security Reminders:
echo    - Monitor logs regularly
echo    - Keep API keys secure
echo    - Update containers regularly
echo    - Backup database regularly

pause