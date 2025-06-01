#!/bin/bash

echo "🔨 Building CursorWatch Screen Monitor..."
echo "========================================"

# Clean previous builds
rm -rf .build

# Build the executable
swift build -c release

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📦 Executable location: .build/release/CursorWatch"
    echo ""
    echo "To run: ./run-screen-watcher.sh"
    echo "Or directly: ./.build/release/CursorWatch"
else
    echo "❌ Build failed!"
    exit 1
fi 
