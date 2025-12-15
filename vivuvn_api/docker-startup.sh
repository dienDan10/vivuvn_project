#!/bin/bash

echo "Starting VivuVN Application with Docker..."

# Stop any existing containers
echo "Stopping existing containers..."
docker-compose down

# Build and start the containers
echo "Building and starting containers..."
docker-compose up --build -d

# Wait for services to be ready
echo "Waiting for AI Service to be ready..."
sleep 90

# Check if containers are running
echo "Checking container status..."
docker-compose ps

echo ""
echo "✅ Application started successfully!"
echo ""
echo "🌐 API is available at: http://localhost:5277"
echo "🗄️  Using local SQL Server on host machine"
echo "🏥 Health Check: http://localhost:5277/health"
echo ""
echo "📋 To view logs:"
echo "   docker-compose logs -f vivuvn-api"
echo "   docker-compose logs -f vivuvn-ai-service"
echo ""
echo "🛑 To stop the application:"
echo "   docker-compose down"