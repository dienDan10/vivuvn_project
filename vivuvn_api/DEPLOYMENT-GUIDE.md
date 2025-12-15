# VivuVN API Deployment Guide for Linux VPS

## Overview
This guide covers deploying the VivuVN API to a Linux VPS with SQL Server running in Docker containers.

## Prerequisites

### On Your Linux VPS
1. **Docker** (v20.10+)
2. **Docker Compose** (v2.0+)
3. **Git**
4. At least **8GB RAM** (for SQL Server, API, and AI Service)
5. At least **20GB disk space**

## Step-by-Step Deployment

### 1. Install Docker on Linux VPS

```bash
# Update package index
sudo apt-get update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo apt-get install docker-compose-plugin

# Verify installation
docker --version
docker compose version
```

### 2. Clone Your Repository

```bash
# Clone your project
git clone <your-repository-url>
cd vivuvn_api
```

### 3. Configure Production Environment

```bash
# Create production environment file from template
cp .env.prod.template .env.prod

# Edit the file with your production values
nano .env.prod
```

**Important:** Update these values in `.env.prod`:
- `SA_PASSWORD` - Strong SQL Server password (8+ characters, mixed case, numbers, symbols)
- `JWT_SECRET_KEY` - Generate new secure key for production
- `JWT_ISSUER` - Your production domain
- `JWT_AUDIENCE` - Your production domain
- `BREVO_API_KEY` - Your Brevo API key
- `BREVO_SENDER_EMAIL` - Your verified sender email
- `GOOGLE_MAPS_API_KEY` - Your Google Maps API key
- `GOOGLE_OAUTH_CLIENT_ID` - Your Google OAuth client ID
- `ADMIN_PANEL_URL` - Your admin panel URL

### 4. Configure AI Service

```bash
# Navigate to AI service directory
cd ../vivuvn_ai_service

# Create Docker environment file
cp .env.docker.template .env.docker

# Edit with your configuration
nano .env.docker

# Go back to API directory
cd ../vivuvn_api
```

### 5. Deploy to Production

```bash
# Make deployment script executable
chmod +x deploy-production.sh

# Run deployment
./deploy-production.sh
```

The script will:
- Validate environment configuration
- Pull required Docker images
- Build and start all services (SQL Server, AI Service, API)
- Wait for services to be healthy
- Run health checks

### 6. Verify Deployment

```bash
# Check container status
docker compose -f docker-compose.yml -f docker-compose.prod.yml ps

# Check logs
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f

# Test API health endpoint
curl http://localhost:5277/health
```

## Service Architecture

```
┌─────────────────────────────────────────┐
│         Linux VPS                       │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │   SQL Server Container           │  │
│  │   Port: 1434 → 1433              │  │
│  │   Volume: sqlserver_data         │  │
│  └──────────────────────────────────┘  │
│                ↑                        │
│  ┌──────────────────────────────────┐  │
│  │   VivuVN API Container           │  │
│  │   Port: 5277 → 80                │  │
│  │   Connects to: sqlserver:1433    │  │
│  └──────────────────────────────────┘  │
│                ↑                        │
│  ┌──────────────────────────────────┐  │
│  │   AI Service Container           │  │
│  │   Port: 8000 → 8000              │  │
│  │   Volume: model-cache            │  │
│  └──────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

## Port Configuration

| Service | Internal Port | External Port | Purpose |
|---------|--------------|---------------|---------|
| API | 80 | 5277 | API endpoints |
| SQL Server | 1433 | 1434 | Database access |
| AI Service | 8000 | 8000 | AI predictions |

## Useful Commands

### View Logs
```bash
# All services
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f

# Specific service
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f vivuvn-api
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f sqlserver
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f vivuvn-ai-service
```

### Restart Services
```bash
# All services
docker compose -f docker-compose.yml -f docker-compose.prod.yml restart

# Specific service
docker compose -f docker-compose.yml -f docker-compose.prod.yml restart vivuvn-api
```

### Stop Services
```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml down
```

### Update Deployment
```bash
# Pull latest code
git pull

# Rebuild and restart
./deploy-production.sh
```

## Database Management

### Backup Database
```bash
# Create backup directory
mkdir -p backups

# Backup database
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec sqlserver \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YOUR_SA_PASSWORD' \
  -Q "BACKUP DATABASE [VivuVnDb] TO DISK = N'/var/opt/mssql/backup/VivuVnDb.bak' WITH NOFORMAT, NOINIT, NAME = 'VivuVnDb-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

# Copy backup to host
docker cp vivuvn-sqlserver:/var/opt/mssql/backup/VivuVnDb.bak ./backups/
```

### Restore Database
```bash
# Copy backup to container
docker cp ./backups/VivuVnDb.bak vivuvn-sqlserver:/var/opt/mssql/backup/

# Restore database
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec sqlserver \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YOUR_SA_PASSWORD' \
  -Q "RESTORE DATABASE [VivuVnDb] FROM DISK = N'/var/opt/mssql/backup/VivuVnDb.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
```

### Access SQL Server
```bash
# From within container
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec sqlserver \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YOUR_SA_PASSWORD'

# From external SQL client (SSMS, Azure Data Studio, etc.)
# Server: your-vps-ip,1434
# Username: sa
# Password: YOUR_SA_PASSWORD
```

## Security Considerations

### 1. Firewall Configuration
```bash
# Allow only necessary ports
sudo ufw allow 5277/tcp  # API
sudo ufw allow 22/tcp    # SSH
sudo ufw enable

# DO NOT expose SQL Server port (1434) to public
# Keep it accessible only from localhost or within Docker network
```

### 2. Reverse Proxy (Nginx/Caddy)
Consider using a reverse proxy for:
- HTTPS/SSL termination
- Domain routing
- Rate limiting
- Load balancing

Example Nginx configuration:
```nginx
server {
    listen 80;
    server_name api.yourdomain.com;
    
    location / {
        proxy_pass http://localhost:5277;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 3. Regular Updates
```bash
# Update system packages
sudo apt-get update && sudo apt-get upgrade

# Update Docker images
docker compose -f docker-compose.yml -f docker-compose.prod.yml pull
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 4. Monitor Resources
```bash
# Check container resource usage
docker stats

# Check disk usage
df -h
docker system df
```

## Troubleshooting

### API Not Starting
```bash
# Check logs
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs vivuvn-api

# Common issues:
# - Database not ready: Wait longer or check SQL Server logs
# - Connection string error: Verify DB_SERVER=sqlserver in environment
# - Missing environment variables: Check .env.prod file
```

### SQL Server Issues
```bash
# Check SQL Server logs
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs sqlserver

# Verify SQL Server is running
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec sqlserver \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YOUR_SA_PASSWORD' -Q "SELECT @@VERSION"

# Common issues:
# - Insufficient memory: Ensure VPS has at least 2GB RAM for SQL Server
# - Weak password: Must meet SQL Server complexity requirements
```

### AI Service Issues
```bash
# Check AI service logs
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs vivuvn-ai-service

# Test AI service health
curl http://localhost:8000/health

# Common issues:
# - Out of memory: AI service needs at least 1-2GB RAM
# - Model download: First run may take time to download models
```

## Monitoring and Maintenance

### Set Up Log Rotation
Docker logs can grow large. Configure log rotation in Docker daemon:

```bash
# Edit Docker daemon config
sudo nano /etc/docker/daemon.json
```

Add:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

```bash
# Restart Docker
sudo systemctl restart docker
```

### Scheduled Backups
Create a cron job for automated backups:

```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * /path/to/backup-script.sh
```

## Performance Tuning

### SQL Server Memory Configuration
```bash
# Connect to SQL Server
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec sqlserver \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YOUR_SA_PASSWORD'

# Set max memory (in MB)
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'max server memory', 2048;  -- 2GB
RECONFIGURE;
GO
```

### Resource Limits
Adjust in `docker-compose.prod.yml` based on your VPS capacity.

## Support

For issues or questions:
1. Check logs first
2. Review this guide
3. Contact your development team
4. Check Docker and SQL Server documentation

## Quick Reference

**Start production:** `./deploy-production.sh`  
**View logs:** `docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f`  
**Stop services:** `docker compose -f docker-compose.yml -f docker-compose.prod.yml down`  
**Restart services:** `docker compose -f docker-compose.yml -f docker-compose.prod.yml restart`  
**Check status:** `docker compose -f docker-compose.yml -f docker-compose.prod.yml ps`
