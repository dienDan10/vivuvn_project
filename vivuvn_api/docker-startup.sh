#!/bin/bash

echo "Starting VivuVN Application with Docker..."

# Create images directory if it doesn't exist
mkdir -p ./images

# Stop any existing containers
echo "Stopping existing containers..."
docker-compose down

# Build and start the containers
echo "Building and starting containers..."
docker-compose up --build -d

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to be ready..."
sleep 30

# Check if containers are running
echo "Checking container status..."
docker-compose ps

echo ""
echo "? Application started successfully!"
echo ""
echo "?? API is available at: http://localhost:5277"
echo "???  SQL Server is available at: localhost:1434"
echo "   - Username: sa"
echo "   - Password: [Check your .env file]"
echo ""
echo "?? To view logs:"
echo "   docker-compose logs -f vivuvn-api"
echo "   docker-compose logs -f sqlserver"
echo ""
echo "?? To stop the application:"
echo "   docker-compose down"