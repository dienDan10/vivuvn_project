# Use the official .NET 8 SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy csproj file and restore dependencies
COPY vivuvn_api/vivuvn_api.csproj ./vivuvn_api/
RUN dotnet restore ./vivuvn_api/vivuvn_api.csproj

# Copy the rest of the application code
COPY . .

# Build the application
RUN dotnet build ./vivuvn_api/vivuvn_api.csproj -c Release -o /app/build

# Publish the application
RUN dotnet publish ./vivuvn_api/vivuvn_api.csproj -c Release -o /app/publish

# Use the official .NET 8 runtime image for running
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create directory for images (static files)
RUN mkdir -p /app/images

# Copy the published application
COPY --from=build /app/publish .

# Expose the port the app runs on
EXPOSE 80
EXPOSE 443

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/health || exit 1

# Set the entry point
ENTRYPOINT ["dotnet", "vivuvn_api.dll"]