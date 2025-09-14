#!/bin/bash

echo "🛑 Parando WSS13 MVP..."

# Parar backend
if [ -f backend.pid ]; then
    BACKEND_PID=$(cat backend.pid)
    if kill -0 $BACKEND_PID 2>/dev/null; then
        echo "🔧 Parando backend (PID: $BACKEND_PID)..."
        kill $BACKEND_PID
        rm backend.pid
    fi
fi

# Parar outros processos Node.js relacionados
pkill -f "node.*index.js"
pkill -f "nodemon.*index.js"

echo "✅ Serviços parados!"
