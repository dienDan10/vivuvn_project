#!/bin/bash

# VivuVN Docker Setup Script
echo "=========================================="
echo "VivuVN API Docker Setup"
echo "=========================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "? Docker is not installed. Please install Docker Desktop first."
    echo "   Download from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "? Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "? Docker and Docker Compose are installed"

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "? Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

echo "? Docker is running"

# Create images directory
echo "?? Creating images directory..."
mkdir -p ./images

# Copy environment template if .env doesn't exist
if [ ! -f .env ]; then
    if [ -f .env.template ]; then
        echo "?? Creating .env file from template..."
        cp .env.template .env
        echo "??  Please edit the .env file and update the API keys and passwords before running the application."
    else
        echo "??  No .env.template found. Using default configuration."
    fi
fi

# Stop any existing containers
echo "?? Stopping existing containers..."
docker-compose down -v

# Pull required images
echo "?? Pulling required Docker images..."
docker pull mcr.microsoft.com/dotnet/sdk:8.0
docker pull mcr.microsoft.com/dotnet/aspnet:8.0
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Build and start containers
echo "?? Building and starting containers..."
docker-compose up --build -d

# Wait for SQL Server to be ready
echo "? Waiting for SQL Server to be ready..."
echo "   This may take 30-60 seconds..."

# Check if SQL Server is ready
for i in {1..12}; do
    sleep 5
    if docker-compose exec -T sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P VivuVN@123456 -Q "SELECT 1" &>/dev/null; then
        echo "? SQL Server is ready!"
        break
    fi
    echo "   Still waiting... ($((i*5))s)"
done

# Wait a bit more for the API to fully start
echo "? Waiting for API to start..."
sleep 10

# Check container status
echo "?? Container Status:"
docker-compose ps

# Test API health
echo ""
echo "?? Testing API health..."
if curl -f http://localhost:5277/health &>/dev/null; then
    echo "? API is healthy and responding!"
else
    echo "??  API might still be starting up. Check logs with: docker-compose logs -f vivuvn-api"
fi

echo ""
echo "=========================================="
echo "?? Setup Complete!"
echo "=========================================="
echo ""
echo "?? Services:"
echo "   ?? API: http://localhost:5277"
echo "   ?? Swagger: http://localhost:5277/swagger"
echo "   ???  SQL Server: localhost:1434"
echo "      Username: sa"
echo "      Password: [Check your .env file]"
echo ""
echo "?? Useful Commands:"
echo "   View API logs:    docker-compose logs -f vivuvn-api"
echo "   View SQL logs:    docker-compose logs -f sqlserver"
echo "   Stop services:    docker-compose down"
echo "   Restart services: docker-compose restart"
echo ""
echo "???  For troubleshooting, check the README-Docker.md file"