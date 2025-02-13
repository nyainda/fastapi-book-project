#!/bin/bash

# Trap SIGTERM and SIGINT
trap 'kill -TERM $nginx_pid $uvicorn_pid $ngrok_pid; wait $nginx_pid $uvicorn_pid $ngrok_pid' TERM INT

# Start uvicorn
uvicorn main:app --host 0.0.0.0 --port 8000 &
uvicorn_pid=$!

# Start nginx
nginx -g "daemon off;" &
nginx_pid=$!

# Start ngrok (you'll need to set NGROK_AUTHTOKEN as an environment variable)
ngrok http 80 --log=stdout &
ngrok_pid=$!

# Wait for any process to exit
wait -n $nginx_pid $uvicorn_pid $ngrok_pid

# If any process exits, kill the others and exit with error
kill -TERM $nginx_pid $uvicorn_pid $ngrok_pid 2>/dev/null
exit 1