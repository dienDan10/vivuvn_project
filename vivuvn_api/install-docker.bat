@echo off
echo ==========================================
echo VivuVN API Docker Setup
echo ==========================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ? Docker is not installed. Please install Docker Desktop first.
    echo    Download from: https://www.docker.com/products/docker-desktop
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

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ? Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo ? Docker is running

REM Create images directory
echo ?? Creating images directory...
if not exist "images" mkdir images

REM Copy environment template if .env doesn't exist
if not exist ".env" (
    if exist ".env.template" (
        echo ?? Creating .env file from template...
        copy .env.template .env >nul
        echo ??  Please edit the .env file and update the API keys and passwords before running the application.
    ) else (
        echo ??  No .env.template found. Using default configuration.
    )
)

REM Stop any existing containers
echo ?? Stopping existing containers...
docker-compose down -v

REM Pull required images
echo ?? Pulling required Docker images...
docker pull mcr.microsoft.com/dotnet/sdk:8.0
docker pull mcr.microsoft.com/dotnet/aspnet:8.0
docker pull mcr.microsoft.com/mssql/server:2022-latest

REM Build and start containers
echo ?? Building and starting containers...
docker-compose up --build -d

REM Wait for SQL Server to be ready
echo ? Waiting for SQL Server to be ready...
echo    This may take 30-60 seconds...
timeout /t 30 /nobreak >nul

REM Wait a bit more for the API to fully start
echo ? Waiting for API to start...
timeout /t 10 /nobreak >nul

REM Check container status
echo ?? Container Status:
docker-compose ps

echo.
echo ==========================================
echo ?? Setup Complete!
echo ==========================================
echo.
echo ?? Services:
echo    ?? API: http://localhost:5277
echo    ?? Swagger: http://localhost:5277/swagger
echo    ???  SQL Server: localhost:1434
echo       Username: sa
echo       Password: [Check your .env file]
echo.
echo ?? Useful Commands:
echo    View API logs:    docker-compose logs -f vivuvn-api
echo    View SQL logs:    docker-compose logs -f sqlserver
echo    Stop services:    docker-compose down
echo    Restart services: docker-compose restart
echo.
echo ???  For troubleshooting, check the README-Docker.md file

pause