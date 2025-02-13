FROM python:3.9-slim

WORKDIR /app

# Install nginx, ngrok and dependencies
RUN apt-get update && \
    apt-get install -y nginx wget unzip && \
    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok-v3-stable-linux-amd64.zip && \
    mv ngrok /usr/local/bin && \
    rm ngrok-v3-stable-linux-amd64.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --system nginx && \
    adduser --system --ingroup nginx nginx && \
    mkdir -p /var/log/nginx /var/run && \
    chown -R nginx:nginx /var/log/nginx /var/run && \
    chmod -R 755 /var/log/nginx /var/run

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY api/ /app/api/
COPY core/ /app/core/
COPY tests/ /app/tests/
COPY main.py /app/

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy modified start script
COPY start.sh /app/
RUN chmod +x /app/start.sh

EXPOSE 80

CMD ["/app/start.sh"]