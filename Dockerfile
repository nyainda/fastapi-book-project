FROM nginx:alpine

# Copy the Nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Make sure PORT is available during runtime
ENV PORT=80

# Command to start Nginx
CMD sed -i "s/\$PORT/$PORT/g" /etc/nginx/nginx.conf && nginx -g 'daemon off;'