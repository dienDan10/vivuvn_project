@echo off
echo ==========================================
echo VivuVN Docker Installation
echo ==========================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ? Docker is NOT installed
    echo.
    echo Please install Docker Desktop for Windows:
    echo 1. Download from: https://www.docker.com/products/docker-desktop
    echo 2. Run the installer
    echo 3. Restart your computer
    echo 4. Start Docker Desktop
    echo 5. Run this script again
    echo.
    pause
    exit /b 1
)

REM Check if Docker Compose is installed (comes with Docker Desktop)
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ? Docker Compose is not available
    echo Docker Desktop should include docker-compose by default.
    echo Please reinstall Docker Desktop.
    pause
    exit /b 1
)

echo ? Docker and Docker Compose are installed
docker --version
docker-compose --version

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ? Docker is not running
    echo Please start Docker Desktop and wait for it to be ready
    echo Then run this script again
    pause
    exit /b 1
)

echo ? Docker is running
echo.
echo ==========================================
echo ?? Installation Complete!
echo ==========================================
echo.
echo ? Docker Desktop is installed and running
echo ? docker-compose is available
echo.
echo ?? Next Steps:
echo    1. For local development: Run docker-startup.bat
echo    2. For production: Use deploy-production.sh on Linux server
echo.
echo ?? Useful Commands:
echo    Check version:    docker --version
echo    Check compose:    docker-compose --version
echo    Test Docker:      docker run hello-world
echo.
pause