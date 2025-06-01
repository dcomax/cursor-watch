# CursorWatch Usage Guide

## Quick Start

1. **Open the project**: Run `./run-dev.sh` or `npm run dev`
2. **Build in Xcode**: The project will open in Xcode automatically
3. **Set your team**: In project settings, select your Apple Developer team
4. **Run the app**: Press Cmd+R or click the Run button
5. **Grant permissions**: Allow screen recording when prompted

## First Run Setup

### Screen Recording Permission
When you first run the app, macOS will ask for screen recording permission:

1. Click "Open System Preferences"
2. Check the box next to "CursorWatch"
3. Restart the app

### Notification Permission
The app will also request notification permission to alert you when text is detected.

## Using the App

### Basic Operation
1. **Configure Search Text**: Enter the text you want to watch for in the text field
2. **Start Monitoring**: Click the "Start Monitoring" button
3. **Background Operation**: The app will monitor your screen every 2 seconds
4. **Receive Alerts**: Get notifications when target text appears

### Default Search Patterns
The app automatically searches for these Cursor-related patterns:
- "cursor editor has ended its tasks"
- "cursor editor has ended"
- "cursor has stopped"
- "cursor not responding"
- "task completed"

### Custom Search Text
- Enter any text pattern you want to detect
- The search is case-insensitive
- Partial matches are supported
- Press Enter to update the search patterns

### Detection History
- View recent detections in the scrollable list
- Each detection shows timestamp and detected text
- History is limited to 50 most recent detections
- Use "Clear Log" to reset the history

## Advanced Usage

### Running in Background
- The app continues monitoring even when the window is closed
- Look for the app icon in the dock or menu bar
- You can quit the app completely using Cmd+Q

### Multiple Monitors
- The app monitors your primary display by default
- Detection works across all content on the monitored screen

### Performance Optimization
- Screenshots are taken every 2 seconds (configurable in code)
- OCR processing is optimized for performance
- Minimal CPU usage when text patterns don't match

## Troubleshooting

### App Can't Capture Screen
**Problem**: App shows errors about screen capture
**Solution**: 
1. Go to System Preferences > Security & Privacy > Screen Recording
2. Ensure CursorWatch is listed and checked
3. Restart the app

### Text Not Being Detected
**Problem**: Expected text appears but isn't detected
**Solutions**:
- Ensure text has good contrast (dark text on light background works best)
- Check that your search pattern matches the actual text
- Try making the text larger on screen
- Verify the text is actually visible (not hidden behind other windows)

### High CPU Usage
**Problem**: App using too much CPU
**Solutions**:
- Close other intensive applications
- Increase the monitoring interval in the code (edit `ScreenMonitor.swift`)
- Restart the app to clear any memory issues

### Notifications Not Working
**Problem**: Not receiving alerts when text is detected
**Solutions**:
1. Check System Preferences > Notifications > CursorWatch
2. Ensure notifications are enabled
3. Check "Do Not Disturb" settings

### App Won't Start
**Problem**: App crashes on launch
**Solutions**:
- Ensure you're running macOS 13.0 or later
- Check that all required frameworks are available
- Try rebuilding the app in Xcode

## Privacy and Security

### Data Privacy
- All processing happens locally on your device
- No data is sent to external servers
- Screenshots are processed in memory only
- Detection history is temporary (not saved to disk)

### Security Considerations
- The app requires screen recording permission
- Only the minimum necessary permissions are requested
- Code is open source for transparency

## Building and Distribution

### Development Build
```bash
./run-dev.sh  # Opens in Xcode for development
```

### Release Build
```bash
./build.sh    # Creates distributable app
```

### Manual Build
1. Open `CursorWatch.xcodeproj` in Xcode
2. Select your development team
3. Choose Product > Archive
4. Export for distribution

## Customization

### Modifying Search Patterns
Edit `ContentView.swift` in the `updateSearchPatterns()` function to add default patterns.

### Changing Monitoring Frequency
Edit `ScreenMonitor.swift` and modify the timer interval in `startPeriodicCapture()`.

### UI Customization
The interface is built with SwiftUI - edit `ContentView.swift` to modify the appearance.

## Support

If you encounter issues:
1. Check this usage guide
2. Review the main README.md
3. Check Xcode console for error messages
4. Ensure all system requirements are met 
