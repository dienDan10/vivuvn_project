@echo off
echo Starting VivuVN Application with Docker...

REM Create images directory if it doesn't exist
if not exist "images" mkdir images

REM Stop any existing containers (this removes containers but preserves data)
echo Stopping and removing existing containers...
echo Note: This removes containers but preserves your database data in volumes
docker-compose down

REM Build and start the containers
echo Building and starting containers...
docker-compose up --build -d

REM Wait for SQL Server to be ready
echo Waiting for SQL Server to be ready...
echo This may take up to 2 minutes for the first startup...
timeout /t 60 /nobreak >nul

REM Wait for AI Service to be ready
echo Waiting for AI Service to be ready...
echo This may take up to 3 minutes for the first startup (downloading ML models)...
timeout /t 90 /nobreak >nul

REM Check if SQL Server is healthy
echo Checking SQL Server health status...
docker inspect vivuvn-sqlserver --format="{{.State.Health.Status}}"

REM Check if AI Service is healthy
echo Checking AI Service health status...
docker inspect vivuvn-ai-service --format="{{.State.Health.Status}}"

REM Check if containers are running
echo Checking container status...
docker-compose ps

echo.
echo ? Application started successfully!
echo.
echo ?? API is available at: http://localhost:5277
echo ???  SQL Server is available at: localhost:1434
echo    - Username: sa
echo    - Password: [Check your .env file]
echo.
echo ?? To view logs:
echo    docker-compose logs -f vivuvn-api
echo    docker-compose logs -f sqlserver
echo.
echo ?? To stop the application:
echo    docker-compose down    (stops and removes containers)
echo    docker-compose stop    (stops containers but keeps them)
echo.
echo ?? To restart without rebuilding:
echo    docker-compose start   (if containers exist but stopped)
echo    docker-compose up -d   (recreates containers if removed)

pause