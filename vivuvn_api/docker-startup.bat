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
echo ???  Using local SQL Server on host machine (localhost:1433)
echo ?? Health Check: http://localhost:5277/health
echo.
echo ?? To view logs:
echo    docker-compose logs -f vivuvn-api
echo    docker-compose logs -f vivuvn-ai-service
echo.
echo ?? To stop:
echo    docker-compose down
echo.
pause