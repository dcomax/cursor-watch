#!/bin/bash

# Cursor Watch Build Script
# This script builds the macOS app using xcodebuild

set -e

echo "🚀 Building Cursor Watch..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/

# Create build directory
mkdir -p build

# Build the app
echo "🔨 Building app..."
xcodebuild -project CursorWatch.xcodeproj \
           -scheme CursorWatch \
           -configuration Release \
           -derivedDataPath build/DerivedData \
           -archivePath build/CursorWatch.xcarchive \
           archive

# Export the app
echo "📦 Exporting app..."
xcodebuild -exportArchive \
           -archivePath build/CursorWatch.xcarchive \
           -exportPath build/Export \
           -exportOptionsPlist ExportOptions.plist

echo "✅ Build complete! App is available in build/Export/"
echo "💡 You can now run the app or distribute it." 
