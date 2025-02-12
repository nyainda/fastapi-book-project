#!/bin/bash

# Trap SIGTERM and SIGINT
trap 'kill -TERM $nginx_pid $uvicorn_pid; wait $nginx_pid $uvicorn_pid' TERM INT

# Start nginx in the background
nginx -g "daemon off;" &
nginx_pid=$!

# Start uvicorn with the correct path
# Using main:app since main.py is in the /app directory
uvicorn main:app --host 0.0.0.0 --port 8000 &
uvicorn_pid=$!

# Wait for either process to exit
wait -n $nginx_pid $uvicorn_pid

# If either process exits, kill the other and exit with error
kill -TERM $nginx_pid $uvicorn_pid 2>/dev/null
exit 1