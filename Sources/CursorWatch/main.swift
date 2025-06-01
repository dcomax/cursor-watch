import Foundation
import AppKit
import Vision

@main
struct CursorWatch {
    static func main() async {
        print("🔍 CursorWatch - Visual Change Detection")
        print("======================================")
        print("Monitoring screen for visual activity...")
        print("📱 Press Ctrl+C to stop")
        print("")
        
        let watcher = VisualChangeWatcher()
        await watcher.start()
    }
}

@MainActor
class VisualChangeWatcher: NSObject {
    private let checkInterval: TimeInterval = 1.0  // Check every second
    private let alertInterval: TimeInterval = 5.0  // Alert every 5 seconds
    private let targetAppName = "Cursor"  // App to monitor
    
    private var isRunning = true
    private var previousImage: CGImage?
    private var lastChangeTime = Date()
    private var lastAlert = Date.distantPast
    
    func start() async {
        await requestPermissions()
        startMonitoring()
        
        // Keep the app running
        while isRunning {
            try? await Task.sleep(for: .seconds(1))
        }
    }
    
    private func requestPermissions() async {
        print("📱 Requesting screen recording permissions...")
        
        let granted = CGRequestScreenCaptureAccess()
        if granted {
            print("✅ Screen recording permission granted")
        } else {
            print("❌ Screen recording permission required")
            print("Please grant screen recording permission in System Preferences > Privacy & Security > Screen Recording")
            exit(1)
        }
    }
    
    private func startMonitoring() {
        print("🎯 CursorWatch monitoring Cursor windows")
        print("⏱️ Will alert every \(Int(alertInterval)) seconds during inactivity")
        print("")
        
        // Initialize alert timing
        lastAlert = Date()
        
        Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { _ in
            Task { @MainActor in
                await self.checkForChanges()
            }
        }
    }
    
    private func checkForChanges() async {
        // Get list of all windows
        guard let windowList = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] else {
            return
        }
        
        // Find Cursor windows
        let cursorWindows = windowList.filter { window in
            if let ownerName = window[kCGWindowOwnerName as String] as? String {
                return ownerName.contains(targetAppName)
            }
            return false
        }
        
        if cursorWindows.isEmpty {
            return
        }
        
        // Capture the largest/main Cursor window
        if let mainWindow = cursorWindows.first,
           let windowID = mainWindow[kCGWindowNumber as String] as? CGWindowID,
           let bounds = mainWindow[kCGWindowBounds as String] as? [String: Any],
           let x = bounds["X"] as? CGFloat,
           let y = bounds["Y"] as? CGFloat,
           let width = bounds["Width"] as? CGFloat,
           let height = bounds["Height"] as? CGFloat {
            
            let windowRect = CGRect(x: x, y: y, width: width, height: height)
            
            guard let cgImage = CGWindowListCreateImage(
                windowRect,
                .optionIncludingWindow,
                windowID,
                []
            ) else {
                return
            }
            
            await compareImages(cgImage)
        }
    }
    
    private func compareImages(_ newImage: CGImage) async {
        defer { previousImage = newImage }
        
        guard let previous = previousImage else {
            // First image - just store it
            return
        }
        
        // Compare images for changes
        let changeInfo = await detectChanges(previous: previous, current: newImage)
        
        let now = Date()
        
        if changeInfo.hasSignificantChanges {
            // Significant changes detected
            print("🔄 [\(timeString(now))] Changes detected - activity resumed")
            lastChangeTime = now
        }
        
        // Always check if we should alert with the count
        let timeSinceLastChange = now.timeIntervalSince(lastChangeTime)
        let timeSinceLastAlert = now.timeIntervalSince(lastAlert)
        
        if timeSinceLastAlert > alertInterval - 0.1 {  // Use > with small buffer for floating point precision
            let seconds = Int(timeSinceLastChange)
            print("⏰ [\(timeString(now))] \(seconds) seconds since last change")
            lastAlert = now
        }
    }
    
    private func detectChanges(previous: CGImage, current: CGImage) async -> (hasSignificantChanges: Bool, changedPixels: Int) {
        // Simple pixel difference detection
        guard previous.width == current.width && previous.height == current.height else {
            return (true, -1) // Different dimensions = change
        }
        
        guard let previousData = previous.dataProvider?.data,
              let currentData = current.dataProvider?.data else {
            return (false, 0)
        }
        
        let previousBytes = CFDataGetBytePtr(previousData)
        let currentBytes = CFDataGetBytePtr(currentData)
        let length = CFDataGetLength(previousData)
        
        // Sample pixels to detect changes (check every 50th pixel for better detection)
        var changedPixels = 0
        let sampleStep = 50
        let changeThreshold: UInt8 = 30 // Minimum color difference to count as change
        
        for i in stride(from: 0, to: length - 4, by: sampleStep * 4) { // 4 bytes per pixel (RGBA)
            // Compare RGB values (ignore alpha)
            let prevR = previousBytes?[i] ?? 0
            let prevG = previousBytes?[i + 1] ?? 0
            let prevB = previousBytes?[i + 2] ?? 0
            
            let currR = currentBytes?[i] ?? 0
            let currG = currentBytes?[i + 1] ?? 0
            let currB = currentBytes?[i + 2] ?? 0
            
            // Calculate color difference
            let rDiff = abs(Int(prevR) - Int(currR))
            let gDiff = abs(Int(prevG) - Int(currG))
            let bDiff = abs(Int(prevB) - Int(currB))
            let totalDiff = rDiff + gDiff + bDiff
            
            if totalDiff > changeThreshold {
                changedPixels += 1
            }
        }
        
        // Require significant number of changed pixels to avoid spinner detection
        let significantChangeThreshold = 50 // Need at least 50 changed pixels (across sampled area)
        let hasSignificantChanges = changedPixels >= significantChangeThreshold
        
        return (hasSignificantChanges, changedPixels)
    }
    
    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
} 
