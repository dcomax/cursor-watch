#!/bin/bash

# CursorWatch Swift Package Build Script
# This builds the app using Swift Package Manager (no Xcode required)

set -e

echo "🚀 Building CursorWatch with Swift Package Manager..."

# Check if Swift is available
if ! command -v swift &> /dev/null; then
    echo "❌ Swift not found. Please install Swift toolchain or Xcode Command Line Tools:"
    echo "   - Xcode Command Line Tools: xcode-select --install"
    echo "   - Swift toolchain: https://swift.org/download/"
    exit 1
fi

echo "✅ Swift found: $(swift --version | head -n1)"

# Build the package
echo "🔨 Building package..."
swift build -c release

echo "✅ Build complete!"
echo "📍 Executable is at: .build/release/CursorWatch"
echo "🚀 Run with: ./.build/release/CursorWatch"
echo ""
echo "💡 Note: You'll need to grant screen recording permission when running" 
