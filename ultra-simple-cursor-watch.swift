#!/usr/bin/env swift

import Foundation

// Ultra Simple Cursor Watch - Pure Foundation Only
print("🔍 Ultra Simple Cursor Watch")
print("============================")
print("Monitoring clipboard for Cursor editor status messages...")
print("📝 Press Ctrl+C to stop\n")

let searchPatterns = [
    "cursor editor has ended its tasks",
    "cursor editor has ended", 
    "cursor has stopped",
    "cursor not responding",
    "task completed",
    "test prompt",  // Added for your test!
    "watcher does"  // Added for your test!
]

var lastClipboard = ""
var isRunning = true

func checkText(_ text: String) {
    let lowercaseText = text.lowercased()
    
    for pattern in searchPatterns {
        if lowercaseText.contains(pattern.lowercased()) {
            let timestamp = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            
            print("🎯 DETECTED at \(formatter.string(from: timestamp)):")
            print("   Pattern: '\(pattern)'")
            print("   Text: \(text.prefix(100))...")
            print("")
            
            // Simple terminal bell notification
            print("\u{07}", terminator: "") // ASCII bell character
            
            // Show macOS notification using system command
            let escapedMessage = text.replacingOccurrences(of: "\"", with: "\\\"")
            let command = "osascript -e 'display notification \"\(escapedMessage)\" with title \"Cursor Watch Alert\"'"
            
            let task = Process()
            task.launchPath = "/bin/sh"
            task.arguments = ["-c", command]
            try? task.run()
            
            break
        }
    }
}

// Monitor clipboard in a simple loop
func startMonitoring() {
    print("🚀 Starting clipboard monitoring...")
    print("📝 Watching for these patterns:")
    for pattern in searchPatterns {
        print("   - \(pattern)")
    }
    print("")
    
    while isRunning {
        // Use pbpaste command to get clipboard content
        let task = Process()
        task.launchPath = "/usr/bin/pbpaste"
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let clipboard = String(data: data, encoding: .utf8) {
                if clipboard != lastClipboard && !clipboard.isEmpty {
                    lastClipboard = clipboard
                    checkText(clipboard)
                }
            }
        } catch {
            // Ignore clipboard read errors
        }
        
        // Wait 2 seconds before checking again
        Thread.sleep(forTimeInterval: 2.0)
    }
}

// Handle Ctrl+C gracefully
signal(SIGINT) { _ in
    print("\n🛑 Stopping Cursor Watch...")
    isRunning = false
    exit(0)
}

// Start monitoring
startMonitoring() 
