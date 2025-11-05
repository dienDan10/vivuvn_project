# =============================================================================
# Stage 1: Builder - Install dependencies
# =============================================================================
FROM python:3.11-slim-bookworm AS builder

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    cmake \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file first (for layer caching)
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies directly (no venv needed in Docker)
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    # Aggressive cleanup to reduce image size by ~500MB
    find /usr/local/lib/python3.11/site-packages -type d -name "tests" -exec rm -rf {} + 2>/dev/null || true && \
    find /usr/local/lib/python3.11/site-packages -type d -name "test" -exec rm -rf {} + 2>/dev/null || true && \
    find /usr/local/lib/python3.11/site-packages -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true && \
    find /usr/local/lib/python3.11/site-packages -type f -name "*.pyc" -delete && \
    find /usr/local/lib/python3.11/site-packages -type f -name "*.pyo" -delete && \
    find /usr/local/lib/python3.11/site-packages -name "*.dist-info" -type d -exec rm -rf {}/RECORD \; 2>/dev/null || true && \
    # Remove pip cache and unnecessary files
    rm -rf /root/.cache/pip && \
    rm -rf /tmp/*

# NOTE: Using Google Gemini embeddings (cloud API), no local models needed
# This significantly reduces image size compared to local ML models

# =============================================================================
# Stage 2: Runtime - Minimal production image
# =============================================================================
FROM python:3.11-slim-bookworm AS runtime

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # Set default environment (can be overridden)
    HOST=0.0.0.0 \
    PORT=8000 \
    DEBUG=False \
    LOG_LEVEL=INFO

# Install runtime dependencies only
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Required for some Python packages
    libgomp1 \
    # Useful for debugging (optional, can be removed for smaller image)
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN groupadd -r vivuapp && useradd -r -g vivuapp vivuapp

# Create app directory
WORKDIR /app

# CRITICAL: Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# NOTE: Using cloud-based Gemini embeddings, no local model cache needed
# Benefits:
# 1. Much smaller image size (~1GB vs 2.5-3GB with local models)
# 2. No model download wait time on first startup
# 3. Automatic model updates from Google
# 4. Consistent performance across all deployments

# Copy application code
COPY --chown=vivuapp:vivuapp app/ /app/app/
COPY --chown=vivuapp:vivuapp requirements.txt /app/

# NOTE: Data directory should be mounted as volume, not copied into image
# This saves image size (~4MB) and allows easy updates without rebuild
# Uncomment only if you need data embedded in image (not recommended)
# COPY --chown=vivuapp:vivuapp data/ /app/data/

# Create directories for logs, temporary files, and data
# These will be mounted as volumes at runtime
RUN mkdir -p /app/logs /app/tmp /app/data && \
    chown -R vivuapp:vivuapp /app

# Switch to non-root user
USER vivuapp

# Expose the application port
EXPOSE 8000

# Run the application
# Uses settings from environment variables or .env file
CMD ["python", "-m", "app.main"]
