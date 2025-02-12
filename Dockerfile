# Use the official Python slim image as the base
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install system dependencies (including nginx)
RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories for nginx
RUN mkdir -p /var/log/nginx /var/run && \
    # Create the 'nginx' user and group if they don't exist
    addgroup --system nginx && \
    adduser --system --ingroup nginx nginx && \
    # Set ownership and permissions for nginx directories
    chown -R nginx:nginx /var/log/nginx /var/run && \
    chmod -R 755 /var/log/nginx /var/run

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY api/ /app/api/
COPY core/ /app/core/
COPY tests/ /app/tests/
COPY main.py /app/

# Copy Nginx configuration files
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy the start script and make it executable
COPY start.sh /app/
RUN chmod +x /app/start.sh

# Expose ports
EXPOSE 80 8000

# Set the entrypoint
ENTRYPOINT ["/app/start.sh"]