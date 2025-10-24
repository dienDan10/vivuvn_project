@echo off
REM VivuVN Docker Security Setup Script
echo ==========================================
echo VivuVN Docker Security Setup
echo ==========================================

REM Check if .env file exists
if exist ".env" (
    echo ??  .env file already exists. Backing up to .env.backup
    copy .env .env.backup >nul
)

echo ?? Creating secure .env file from template...
copy .env.template .env >nul

REM Generate a basic JWT key (Windows doesn't have openssl by default)
echo ?? Please generate a secure JWT key manually

echo.
echo ?? Security Setup Complete!
echo.
echo ?? IMPORTANT: Please edit the .env file and:
echo    1. Replace JWT_SECRET_KEY with a secure 64-character key
echo    2. Set your BREVO_API_KEY
echo    3. Set your BREVO_SENDER_EMAIL
echo    4. Set your GOOGLE_MAPS_API_KEY
echo    5. Set your GOOGLE_OAUTH_CLIENT_ID
echo    6. Change SA_PASSWORD to a strong password
echo.
echo ??  NEVER commit the .env file to version control!
echo ??  Add .env to your .gitignore file
echo.
echo ?? Edit .env file:
echo    notepad .env
echo.
echo ?? Generate JWT key online:
echo    https://generate-random.org/api-key-generator

pause