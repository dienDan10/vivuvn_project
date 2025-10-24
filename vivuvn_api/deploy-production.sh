#!/bin/bash

# VivuVN Production Deployment Script
echo "=========================================="
echo "VivuVN Production Deployment"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}? $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}??  $1${NC}"
}

print_error() {
    echo -e "${RED}? $1${NC}"
}

# Check if running as root (recommended for production)
if [[ $EUID -eq 0 ]]; then
   print_warning "Running as root. This is OK for production deployment."
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_status "Docker and Docker Compose are installed"

# Check if production environment file exists
if [ ! -f .env.prod ]; then
    print_error "Production environment file (.env.prod) not found!"
    echo "Please create .env.prod from .env.prod.template with production values."
    exit 1
fi

print_status "Production environment file found"

# Validate production environment (basic check)
if grep -q "CHANGE-TO-" .env.prod; then
    print_error "Production environment file contains placeholder values!"
    echo "Please update all placeholder values in .env.prod before deploying."
    exit 1
fi

print_status "Production environment file appears to be configured"

# Stop any existing containers
echo "?? Stopping existing containers..."
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

# Pull latest images
echo "?? Pulling latest base images..."
docker pull mcr.microsoft.com/dotnet/sdk:8.0
docker pull mcr.microsoft.com/dotnet/aspnet:8.0
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Build and start production containers
echo "?? Building and starting production containers..."
docker-compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod up --build -d

# Wait for services to be ready
echo "? Waiting for services to be ready..."
sleep 60

# Check container status
echo "?? Container Status:"
docker-compose -f docker-compose.yml -f docker-compose.prod.yml ps

# Health check
echo "?? Testing API health..."
sleep 10

if curl -f http://localhost:5277/health &>/dev/null; then
    print_status "API is healthy and responding!"
else
    print_warning "API health check failed. Check logs with: docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f vivuvn-api"
fi

echo ""
echo "=========================================="
echo "?? Production Deployment Complete!"
echo "=========================================="
echo ""
echo "?? Production Services:"
echo "   ?? API: http://localhost:5277"
echo "   ???  SQL Server: localhost:1434"
echo "   ?? Health Check: http://localhost:5277/health"
echo ""
echo "?? Production Commands:"
echo "   View logs:    docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f"
echo "   Stop:         docker-compose -f docker-compose.yml -f docker-compose.prod.yml down"
echo "   Restart:      docker-compose -f docker-compose.yml -f docker-compose.prod.yml restart"
echo ""
echo "?? Security Reminders:"
echo "   - Monitor logs regularly"
echo "   - Keep API keys secure"
echo "   - Update containers regularly"
echo "   - Backup database regularly"