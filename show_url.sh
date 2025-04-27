#!/bin/bash

# Set working directory
cd /home/facilities/Desktop/ollama_api

# Query ngrok local API for current public URL
URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*')

if [ -z "$URL" ]; then
    echo "No active ngrok tunnel found."
else
    echo "Your public URL is: $URL"
fi
