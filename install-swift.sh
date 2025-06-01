#!/bin/bash

# Swift Installation Helper for CursorWatch
# This helps install the minimum requirements to build and run the app

echo "🔧 CursorWatch Installation Helper"
echo "=================================="

# Check if Swift is already available
if command -v swift &> /dev/null; then
    echo "✅ Swift is already installed: $(swift --version | head -n1)"
    echo "🚀 You can now run: ./swift-build.sh"
    exit 0
fi

echo "❌ Swift not found on your system"
echo ""
echo "Choose an installation option:"
echo ""
echo "1️⃣  Xcode Command Line Tools (Recommended - ~500MB)"
echo "   - Includes Swift, compilers, and development tools"
echo "   - Command: xcode-select --install"
echo ""
echo "2️⃣  Standalone Swift Toolchain (~200MB)"
echo "   - Just Swift compiler and runtime"
echo "   - Download from: https://swift.org/download/"
echo ""

read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "🔧 Installing Xcode Command Line Tools..."
        xcode-select --install
        echo ""
        echo "✅ After installation completes, run: ./swift-build.sh"
        ;;
    2)
        echo "🌐 Opening Swift download page..."
        open "https://swift.org/download/"
        echo ""
        echo "📝 Instructions:"
        echo "1. Download the macOS Swift toolchain"
        echo "2. Install the .pkg file"
        echo "3. Add Swift to your PATH if needed"
        echo "4. Run: ./swift-build.sh"
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac 
