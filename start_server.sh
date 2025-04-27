#!/bin/bash

# Set working directory
cd /home/facilities/Desktop/ollama_api

# Load environment variables (optional for other things)
export $(grep -v '^#' .env | xargs)

# Make sure logs folder exists
mkdir -p logs

# Kill anything using port 8000
echo "Killing processes using port 8000..."
fuser -k 8000/tcp

sleep 1

# Start uvicorn server
echo "Starting FastAPI uvicorn server..."
nohup uvicorn inference_api:app --host 0.0.0.0 --port 8000 > logs/fastapi.log 2>&1 &

sleep 5

# Kill old ngrok tunnels
echo "Killing old ngrok tunnels if any..."
pkill -f "ngrok http 8000"

sleep 1

# Start ngrok and auto-restart if it crashes
echo "Starting persistent ngrok tunnel..."
while true
do
  /usr/local/bin/ngrok http 8000 --log=stdout > logs/ngrok.log 2>&1
  echo "ngrok exited. Restarting in 5 seconds..."
  sleep 5
done
