@echo off
echo Starting VivuVN Application with Docker...

REM Stop any existing containers
echo Stopping and removing existing containers...
docker-compose down

REM Build and start the containers
echo Building and starting containers...
docker-compose up --build -d

REM Wait for AI Service to be ready
echo Waiting for AI Service to be ready...
timeout /t 90 /nobreak >nul

REM Check if containers are running
echo Checking container status...
docker-compose ps

echo.
echo ? Application started successfully!
echo.
echo ?? API is available at: http://localhost:5277
echo ???  Using local SQL Server on host machine
echo.
pause