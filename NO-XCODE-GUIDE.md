# Running Cursor Watch Without Xcode

**Good news!** You have several options to run Cursor Watch without installing the full Xcode IDE.

## 🚀 Instant Start (No Installation)

### Option 1: Standalone Script ⭐ **RECOMMENDED**

```bash
# Just run it - no setup required!
./simple-cursor-watch.swift
```

**What it does:**
- ✅ Monitors clipboard for Cursor-related text
- ✅ Tracks running Cursor processes
- ✅ Sends native macOS notifications
- ✅ Zero installation required
- ✅ Works with built-in macOS Swift

**Limitations:**
- ❌ No screen OCR (doesn't read text from screen images)
- ❌ Command-line interface only

## 🛠 Advanced Options (Small Downloads)

### Option 2: Swift Package Manager

**Step 1: Install Swift toolchain**
```bash
./install-swift.sh  # Helps you choose the right option
```

**Step 2: Build and run**
```bash
./swift-build.sh    # Build once
./swift-run.sh      # Run anytime
```

**What it includes:**
- ✅ More advanced monitoring
- ✅ Better pattern matching
- ✅ Smaller download than Xcode (~200-500MB vs 10GB)

### Option 3: Xcode Command Line Tools Only

```bash
# Install just the command line tools
xcode-select --install

# Then use the build scripts
./build.sh          # Creates full app bundle
```

## 📊 Comparison

| Method | Download Size | Setup Time | Features | Best For |
|--------|---------------|------------|----------|----------|
| **Standalone Script** | 0MB | 0 seconds | Basic | Quick testing |
| **Swift Package** | 200-500MB | 2-5 minutes | Advanced | Regular use |
| **Command Line Tools** | ~500MB | 5-10 minutes | Full CLI | Power users |
| **Full Xcode** | ~10GB | 30+ minutes | Everything | Developers |

## 🎯 Quick Decision Guide

**Just want to try it?**
→ Use the standalone script: `./simple-cursor-watch.swift`

**Want screen OCR monitoring?**
→ Install command line tools: `xcode-select --install`

**Don't want Xcode at all?**
→ Use Swift Package Manager: `./install-swift.sh`

**Want the full GUI app?**
→ Install Xcode and use: `./run-dev.sh`

## 🔧 Troubleshooting

### "Permission denied"
```bash
chmod +x simple-cursor-watch.swift
```

### "Swift not found"
```bash
# Option A: Install command line tools
xcode-select --install

# Option B: Install Swift toolchain only
./install-swift.sh
```

### Script won't execute
```bash
# Try running with swift directly
swift simple-cursor-watch.swift
```

## 💡 Pro Tips

1. **Start with the standalone script** - it works immediately and helps you understand what the app does

2. **The standalone version is often enough** - it catches most Cursor status messages through clipboard monitoring

3. **If you need screen OCR**, go with command line tools rather than full Xcode

4. **All versions are privacy-focused** - everything runs locally on your Mac

## 🚀 Ready to Start?

**Quickest path:**
```bash
cd /path/to/cursor-watch
./simple-cursor-watch.swift
```

The app will start monitoring immediately and show you exactly what it's watching for. Press Ctrl+C when you want to stop.

That's it! No Xcode required. 🎉 
