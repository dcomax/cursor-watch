#!/bin/bash

EXECUTABLE=".build/release/CursorWatch"

# Check if executable exists
if [ ! -f "$EXECUTABLE" ]; then
    echo "❌ Executable not found. Building first..."
    ./build-screen-watcher.sh
    echo ""
fi

# Check again after potential build
if [ ! -f "$EXECUTABLE" ]; then
    echo "❌ Build failed or executable not found"
    exit 1
fi

echo "🚀 Starting CursorWatch Screen Monitor..."
echo "========================================="
echo ""
echo "⚠️  This will request screen recording permission on first run"
echo "📱 You'll see system permission dialogs - please allow them"
echo ""

# Run the executable
"$EXECUTABLE" 
