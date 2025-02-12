#!/bin/bash
# start.sh

# Start nginx
service nginx start

# Start FastAPI
uvicorn app.main:app --host 0.0.0.0 --port 8000