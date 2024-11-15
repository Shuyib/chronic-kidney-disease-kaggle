# Stage 1: Build Stage
FROM python:3.10.12-slim-buster AS builder

# Meta-data
LABEL maintainer="Shuyib" \
      description="Docker Data Science workflow: Feature engineering and modelling for the chronic kidney disease dataset." \
      version="1.0" \
      security="SECURITY_CONTACT=check my github profile"

# Install build dependencies and create virtual environment in a single RUN to minimize layers
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    graphviz \
    unzip \
    && python3 -m venv /app/ml-env \
    && /app/ml-env/bin/pip install --no-cache-dir --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r msee && useradd -r -g msee -m -s /bin/bash msee

# Set the working directory
WORKDIR /app

# Copy and install requirements
COPY requirements.txt /app/
RUN /app/ml-env/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Stage
FROM python:3.10.12-slim-buster 

# Meta-data
LABEL maintainer="Shuyib" \
      description="Docker Data Science workflow: Feature engineering and modelling for the chronic kidney disease dataset." \
      version="1.0" \
      security="SECURITY_CONTACT=check my github profile"

# Create non-root user
RUN groupadd -r msee && useradd -r -g msee -m -s /bin/bash msee

# Set the working directory
WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/ml-env /app/ml-env

# Copy application code with correct ownership
COPY --chown=msee:msee . /app/

# Set ownership
RUN chown -R msee:msee /app

# Create mountpoint
VOLUME ["/app/data"]

# Switch to non-root user
USER msee

# Environment variables
ENV PYTHONUNBUFFERED=1

# Expose necessary port
EXPOSE 9999

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:9999 || exit 1

# Run Jupyter Lab
CMD ["/app/ml-env/bin/jupyter", "lab", "--ip=0.0.0.0", "--port=9999", "--no-browser"]