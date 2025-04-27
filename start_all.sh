#!/bin/bash

cd /home/facilities/Desktop/ollama_api

# Load environment variables
export $(grep -v '^#' .env | xargs)

# Make sure logs folder exists
mkdir -p logs

echo "Killing old processes..."

# Kill anything using port 8000
fuser -k 8000/tcp

# Kill old ngrok
pkill -f "ngrok http 8000"

# Kill old watcher
pkill -f "watch_ngrok.py"

sleep 2

echo "Starting FastAPI uvicorn server..."
nohup uvicorn inference_api:app --host 0.0.0.0 --port 8000 > logs/fastapi.log 2>&1 &

sleep 5

echo "Starting persistent ngrok tunnel..."
nohup bash -c "while true; do /usr/local/bin/ngrok http 8000 --log=stdout > logs/ngrok.log 2>&1; echo 'ngrok exited. Restarting in 5 seconds...'; sleep 5; done" > logs/ngrok_loop.log 2>&1 &

sleep 5

echo "Starting Discord watcher..."
nohup python3 watch_ngrok.py > logs/watcher.log 2>&1 &

echo "✅ All services started in background."
