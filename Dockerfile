# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install Nginx and clean up apt cache
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY api/ /app/api/
COPY core/ /app/core/
COPY tests/ /app/tests/
COPY main.py /app/

# Copy Nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx and FastAPI
CMD nginx && uvicorn main:app --host 0.0.0.0 --port 8000