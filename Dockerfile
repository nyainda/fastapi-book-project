# Dockerfile
FROM python:3.9-slim

WORKDIR /app

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Copy and install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Script to start both nginx and FastAPI
COPY start.sh .
RUN chmod +x start.sh

# Expose port
EXPOSE 80

# Start both nginx and FastAPI
CMD ["./start.sh"]