#!/bin/bash

# Development launcher for Cursor Watch
# This script opens the project in Xcode for development

echo "🔧 Opening Cursor Watch in Xcode..."

# Check if Xcode is available
if ! command -v xed &> /dev/null; then
    echo "❌ Xcode command line tools not found. Please install Xcode."
    exit 1
fi

# Open the project in Xcode
xed CursorWatch.xcodeproj

echo "✅ Project opened in Xcode!"
echo "💡 Don't forget to:"
echo "   1. Set your development team in project settings"
echo "   2. Grant screen recording permission when prompted"
echo "   3. Allow notifications for alerts" 
