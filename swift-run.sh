#!/bin/bash

# CursorWatch Swift Package Run Script
# This runs the app directly with Swift Package Manager

set -e

echo "🚀 Running CursorWatch..."

# Check if built
if [ ! -f ".build/release/CursorWatch" ]; then
    echo "📦 App not built yet, building first..."
    ./swift-build.sh
fi

echo "🔧 Starting CursorWatch..."
echo "💡 The app window should appear shortly"
echo "⚠️  If this is your first run, you'll need to grant screen recording permission"
echo ""

# Run the app
./.build/release/CursorWatch 
