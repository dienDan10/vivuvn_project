#!/bin/bash

# VivuVN Docker Security Setup Script
echo "=========================================="
echo "VivuVN Docker Security Setup"
echo "=========================================="

# Function to generate secure random key
generate_jwt_key() {
    openssl rand -base64 64 | tr -d '\n'
}

# Check if .env file exists
if [ -f .env ]; then
    echo "??  .env file already exists. Backing up to .env.backup"
    cp .env .env.backup
fi

echo "?? Creating secure .env file from template..."
cp .env.template .env

# Generate secure JWT key if openssl is available
if command -v openssl &> /dev/null; then
    JWT_KEY=$(generate_jwt_key)
    echo "?? Generated secure JWT key"
    
    # Replace JWT key in .env file
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/JWT_SECRET_KEY=CHANGE-THIS-TO-A-SECURE-64-CHARACTER-SECRET-KEY-FOR-PRODUCTION/JWT_SECRET_KEY=${JWT_KEY}/" .env
    else
        # Linux
        sed -i "s/JWT_SECRET_KEY=CHANGE-THIS-TO-A-SECURE-64-CHARACTER-SECRET-KEY-FOR-PRODUCTION/JWT_SECRET_KEY=${JWT_KEY}/" .env
    fi
else
    echo "??  OpenSSL not found. Please manually replace JWT_SECRET_KEY in .env file"
fi

echo ""
echo "?? Security Setup Complete!"
echo ""
echo "?? IMPORTANT: Please edit the .env file and:"
echo "   1. Set your BREVO_API_KEY"
echo "   2. Set your BREVO_SENDER_EMAIL" 
echo "   3. Set your GOOGLE_MAPS_API_KEY"
echo "   4. Set your GOOGLE_OAUTH_CLIENT_ID"
echo "   5. Change SA_PASSWORD to a strong password"
echo ""
echo "??  NEVER commit the .env file to version control!"
echo "??  Add .env to your .gitignore file"
echo ""
echo "?? Edit .env file:"
echo "   nano .env     # Linux/macOS"
echo "   notepad .env  # Windows"