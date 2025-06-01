# CursorWatch

A native macOS app that monitors your screen for specific text patterns indicating when Cursor editor has completed tasks or stopped working.

## 🎯 What It Does

CursorWatch uses **real screen monitoring with OCR** to detect when Cursor displays messages like:
- "cursor editor has ended its tasks"
- "cursor has finished" 
- "task completed"
- "generation complete"
- "analysis finished"

When detected, it shows a native macOS notification.

## 🚀 Quick Start (Screen Monitoring)

This version does **actual screen OCR monitoring** and requires screen recording permissions:
```bash
# Build and run the screen monitor
./build-screen-watcher.sh
./run-screen-watcher.sh
```

### ⚠️ First Run Setup

1. **Screen Recording Permission**: When you first run, macOS will ask for screen recording permission
2. **Grant Permission**: Go to System Preferences > Privacy & Security > Screen Recording
3. **Add CursorWatch**: Click the + button and add `.build/release/CursorWatch`
4. **Run Again**: Execute `./run-screen-watcher.sh` after granting permission

## 📋 Alternative Versions

### 1. Screen Monitoring (Recommended)
- **File**: `Sources/CursorWatch/main.swift`
- **Build**: `./build-screen-watcher.sh`
- **Run**: `./run-screen-watcher.sh`
- **Requires**: Screen recording permission
- **Monitors**: Actual screen content via OCR
- **Accuracy**: High - detects text anywhere on screen

### 2. Clipboard Monitoring (Simple)
- **File**: `ultra-simple-cursor-watch.swift`
- **Run**: `./ultra-simple-cursor-watch.swift`
- **Requires**: No special permissions
- **Monitors**: Only clipboard content
- **Accuracy**: Limited - only text you manually copy

### 3. Xcode Project (Full Featured)
- **File**: `CursorWatch.xcodeproj`
- **Requires**: Xcode installation
- **Features**: Full native app with GUI

## 🛠 Requirements

- macOS 13.0+ (Ventura)
- Swift 5.9+ (included with Xcode Command Line Tools)
- Screen recording permission (for screen monitoring version)

## 📱 How It Works

### Screen Monitoring Version
1. **Captures Screen**: Uses ScreenCaptureKit to capture display content every 2 seconds
2. **OCR Analysis**: Uses Vision framework to extract text from screenshots
3. **Pattern Matching**: Searches for Cursor-related completion messages
4. **Notifications**: Shows native macOS notifications when patterns are found
5. **Fallback**: If ScreenCaptureKit fails, falls back to periodic screenshots

### Detection Patterns
The app looks for these text patterns (case insensitive):
- "cursor editor has ended its tasks"
- "cursor has finished"
- "task completed" 
- "generation complete"
- "analysis finished"
- "test prompt" (for testing)
- "watcher does" (for testing)

## 🔧 Customization

Edit the `patterns` array in `Sources/CursorWatch/main.swift` to add your own detection patterns:

```swift
private let patterns = [
    "cursor editor has ended its tasks",
    "your custom pattern here",
    // ... add more patterns
]
```

## 🐛 Troubleshooting

### Screen Recording Permission Issues
- Make sure the exact executable path is added to Screen Recording permissions
- Path should be: `/path/to/your/cursor-watch/.build/release/CursorWatch`
- Restart the app after granting permission

### Build Issues
- Ensure you have Xcode Command Line Tools: `xcode-select --install`
- Check Swift version: `swift --version`
- Clean build: `rm -rf .build && ./build-screen-watcher.sh`

### Performance
- The app captures screen every 2 seconds by default
- Adjust `checkInterval` in main.swift to change frequency
- Higher frequency = more responsive but uses more CPU

## 📊 Comparison Table

| Feature | Screen Monitor | Clipboard Monitor | Xcode Project |
|---------|----------------|-------------------|---------------|
| Setup Complexity | Medium | Simple | Complex |
| Permissions | Screen Recording | None | Screen Recording |
| Detection Accuracy | High | Limited | High |
| Performance Impact | Medium | Low | Medium |
| Requires Xcode | No | No | Yes |
| Bundle Requirements | Swift Package | None | Full App Bundle |

## 🎉 Success!

When working correctly, you'll see:
- ✅ Screen recording permission granted
- ✅ Screen capture started  
- 📱 Notification sent: [pattern] (when text is detected)

The app runs continuously in the terminal. Press Ctrl+C to stop.
