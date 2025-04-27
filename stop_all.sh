#!/bin/bash

echo "🛑 Stopping FastAPI server first (port 8000)..."
# Kill anything bound to port 8000 (FastAPI uvicorn)
PID_8000=$(lsof -ti :8000)
if [ ! -z "$PID_8000" ]; then
    kill -9 $PID_8000
    echo "✅ FastAPI server killed (PID $PID_8000)"
else
    echo "✅ No FastAPI server running on port 8000."
fi

sleep 2

echo "🛑 Now stopping ngrok web UI (port 4040 or 4041)..."
# Kill anything bound to port 4040
PID_4040=$(lsof -ti :4040)
PID_4041=$(lsof -ti :4041)

if [ ! -z "$PID_4040" ]; then
    kill -9 $PID_4040
    echo "✅ ngrok web service on 4040 killed (PID $PID_4040)"
fi

if [ ! -z "$PID_4041" ]; then
    kill -9 $PID_4041
    echo "✅ ngrok web service on 4041 killed (PID $PID_4041)"
fi

# Kill ngrok process itself if still running
pkill -9 -f "ngrok http"
pkill -9 -f "/usr/local/bin/ngrok"
pkill -9 -f "ngrok"

sleep 2

echo "🛑 Now stopping Discord watcher..."
pkill -9 -f "watch_ngrok.py" && echo "✅ Discord watcher killed." || echo "✅ No Discord watcher running."

sleep 2

echo ""
echo "📋 Verifying everything is clean:"
sleep 1
lsof -i :8000 || echo "✅ Port 8000 is clean!"
lsof -i :4040 || lsof -i :4041 || echo "✅ No ngrok web service left!"
pgrep -f "watch_ngrok.py" || echo "✅ No Discord watcher left!"

echo ""
echo "✅ All services fully stopped."
