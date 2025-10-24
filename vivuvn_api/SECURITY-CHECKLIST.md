# ?? Security Checklist for VivuVN Docker Setup

## ?? IMMEDIATE ACTIONS REQUIRED

### 1. **Rotate All Exposed API Keys** 
- [ ] **Brevo API Key**: Go to [Brevo Dashboard](https://app.brevo.com/settings/keys/api) ? Revoke old key ? Generate new key
- [ ] **Google Maps API Key**: Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials) ? Delete old key ? Create new key
- [ ] **Google OAuth Client ID**: Update OAuth client configuration if needed

### 2. **Change Database Password**
- [ ] Change `SA_PASSWORD` in your `.env` file to a strong, unique password
- [ ] Use at least 12 characters with mixed case, numbers, and symbols

### 3. **Generate New JWT Secret**
- [ ] Replace `JWT_SECRET_KEY` with a secure 64+ character random string
- [ ] Use `openssl rand -base64 64` or an online generator

## ?? Security Implementation

### Files Updated for Security:
- ? `appsettings.Docker.json` - Now uses environment variable placeholders
- ? `docker-compose.yml` - Now reads from `.env` file  
- ? `.env.template` - Template with placeholder values
- ? `Program.cs` - Replaces placeholders with environment variables
- ? Security setup scripts created

### What's Protected Now:
- ? API keys are externalized to environment variables
- ? Database passwords are not hardcoded
- ? JWT secrets are configurable
- ? Sensitive data won't be committed to Git

## ?? Setup Process

### 1. Run Security Setup
```bash
# Windows
setup-secure-env.bat

# Linux/Mac  
chmod +x setup-secure-env.sh
./setup-secure-env.sh
```

### 2. Edit `.env` File
```bash
# Replace these with your actual values:
BREVO_API_KEY=your-new-brevo-api-key
BREVO_SENDER_EMAIL=your-email@domain.com
GOOGLE_MAPS_API_KEY=your-new-google-maps-key
GOOGLE_OAUTH_CLIENT_ID=your-oauth-client-id
JWT_SECRET_KEY=your-secure-64-character-jwt-secret
SA_PASSWORD=your-strong-database-password
```

### 3. Verify `.gitignore`
Ensure these entries are in your `.gitignore`:
```
.env
.env.local
.env.production
.env.docker.local
appsettings.*.local.json
```

### 4. Run Docker
```bash
docker-compose up --build -d
```

## ?? What NOT to Do

? **NEVER commit to Git:**
- `.env` files
- `appsettings.*.json` files with real secrets
- Any file containing API keys or passwords

? **NEVER share publicly:**
- API keys in screenshots
- Log files containing secrets
- Configuration files with real credentials

? **NEVER use in production:**
- Default passwords (like `VivuVN@123456`)
- Weak JWT secrets
- Exposed API endpoints without authentication

## ? Best Practices

### For Development:
- Use separate API keys for dev/staging/production
- Use weak passwords only for local development
- Keep `.env.template` updated but without real secrets

### For Production:
- Use strong, unique passwords for each environment
- Enable API key restrictions (IP allowlists, referrer restrictions)
- Use Azure Key Vault, AWS Secrets Manager, or similar for cloud deployments
- Enable logging and monitoring for API key usage

### For Team Collaboration:
- Share `.env.template` with placeholder values
- Document which services require API keys
- Use separate API keys for each team member
- Set up proper secrets management in CI/CD pipelines

## ?? Verification Steps

After setup, verify:
- [ ] `.env` file exists and contains real values
- [ ] `.env` is listed in `.gitignore`
- [ ] `appsettings.Docker.json` contains `${VARIABLE}` placeholders
- [ ] Docker containers start successfully
- [ ] API responds at `http://localhost:5277/health`
- [ ] No secrets visible in `docker-compose logs`

## ?? Emergency Response

If secrets were exposed:
1. **Immediately revoke/rotate all API keys**
2. **Change all passwords**  
3. **Check Git history for committed secrets**
4. **Monitor API usage for unauthorized access**
5. **Update team members with new credentials**

## ?? Resources

- [Brevo API Keys](https://app.brevo.com/settings/keys/api)
- [Google Cloud Console](https://console.cloud.google.com/apis/credentials)  
- [JWT Secret Generator](https://generate-random.org/api-key-generator)
- [.NET Configuration Documentation](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/)
- [Docker Secrets Management](https://docs.docker.com/engine/swarm/secrets/)

---

**?? Remember: Security is not optional. Protect your API keys like passwords!**