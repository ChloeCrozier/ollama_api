#!/bin/bash

echo "📋 FastAPI Server Status (port 8000):"
if lsof -i :8000 | grep LISTEN; then
    echo "✅ FastAPI server is running!"
else
    echo "❌ FastAPI server is NOT running."
fi

echo ""
echo "📋 ngrok Tunnel Status:"
if pgrep -f "ngrok http" > /dev/null || lsof -i :4040 || lsof -i :4041; then
    echo "✅ ngrok tunnel is running!"
else
    echo "❌ ngrok tunnel is NOT running."
fi

echo ""
echo "📋 Discord Watcher Status:"
if pgrep -f "watch_ngrok.py" > /dev/null; then
    echo "✅ Discord watcher is running!"
else
    echo "❌ Discord watcher is NOT running."
fi

echo ""
echo "📋 Latest public URL:"
curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*' || curl -s http://localhost:4041/api/tunnels | grep -o 'https://[^"]*' || echo "❌ ngrok URL not found."
