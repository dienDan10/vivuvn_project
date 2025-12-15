#!/bin/bash

# VivuVN Docker Installation Script for Linux
echo "=========================================="
echo "VivuVN Docker Installation"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠  $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

print_status "Starting Docker installation..."

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    print_warning "Docker is already installed"
    docker --version
else
    echo "📦 Installing Docker..."
    
    # Update package index
    apt-get update
    
    # Install prerequisites
    apt-get install -y ca-certificates curl gnupg lsb-release
    
    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    
    print_status "Docker installed successfully"
    docker --version
fi

# Check if Docker Compose is already installed
if command -v docker-compose &> /dev/null; then
    print_warning "Docker Compose is already installed"
    docker-compose --version
else
    echo "📦 Installing Docker Compose..."
    
    # Install Docker Compose V1 (standalone)
    DOCKER_COMPOSE_VERSION="1.29.2"
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    print_status "Docker Compose installed successfully"
    docker-compose --version
fi

# Add current user to docker group (if not root)
if [ -n "$SUDO_USER" ]; then
    usermod -aG docker $SUDO_USER
    print_status "Added $SUDO_USER to docker group"
    print_warning "Please log out and back in for group changes to take effect"
fi

print_status "Docker and Docker Compose installation complete!"

# Start Docker service
echo "🔄 Starting Docker service..."
systemctl start docker
systemctl enable docker

# Verify Docker is running
if ! docker info &> /dev/null; then
    print_error "Docker failed to start. Please check logs: journalctl -u docker"
    exit 1
fi

print_status "Docker is running"

echo ""
echo "=========================================="
echo "✅ Installation Complete!"
echo "=========================================="
echo ""
echo "📝 Next Steps:"
echo "   1. Log out and back in (for group permissions)"
echo "   2. Run: docker --version"
echo "   3. Run: docker-compose --version"
echo "   4. Test: docker run hello-world"
echo "   5. Deploy your application with: ./deploy-production.sh"
echo ""
echo "📚 Useful Commands:"
echo "   Check status:     systemctl status docker"
echo "   View logs:        journalctl -u docker"
echo "   Restart Docker:   systemctl restart docker"
echo ""
print_status "Docker installation complete!"