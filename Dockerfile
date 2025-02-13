FROM python:3.9-slim

WORKDIR /app

# Install nginx and headers-more-nginx-module dependencies
RUN apt-get update && \
    apt-get install -y nginx wget build-essential libpcre3-dev zlib1g-dev libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --system nginx && \
    adduser --system --ingroup nginx nginx && \
    mkdir -p /var/log/nginx /var/run && \
    chown -R nginx:nginx /var/log/nginx /var/run && \
    chmod -R 755 /var/log/nginx /var/run

# Install headers-more-nginx-module
RUN cd /tmp && \
    wget http://nginx.org/download/nginx-1.24.0.tar.gz && \
    wget https://github.com/openresty/headers-more-nginx-module/archive/v0.34.tar.gz && \
    tar -zxf nginx-1.24.0.tar.gz && \
    tar -zxf v0.34.tar.gz && \
    cd nginx-1.24.0 && \
    ./configure --with-compat --add-dynamic-module=../headers-more-nginx-module-0.34 && \
    make modules && \
    mkdir -p /usr/lib/nginx/modules && \
    cp objs/ngx_http_headers_more_filter_module.so /usr/lib/nginx/modules/ && \
    echo "load_module /usr/lib/nginx/modules/ngx_http_headers_more_filter_module.so;" > /etc/nginx/modules/headers-more.conf && \
    cd / && \
    rm -rf /tmp/*

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

# Copy and setup start script
COPY start.sh /app/
RUN chmod +x /app/start.sh

EXPOSE 80

CMD ["/app/start.sh"]