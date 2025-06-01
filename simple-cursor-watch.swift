#!/usr/bin/env swift

import Foundation
import AppKit

// Simple Cursor Watch - Standalone Version
print("🔍 Simple Cursor Watch")
print("======================")
print("Monitoring for Cursor editor status messages...")
print("💡 This version monitors the clipboard and running processes")
print("📝 Press Ctrl+C to stop\n")

class SimpleCursorWatch {
    private var isRunning = true
    private let searchPatterns = [
        "cursor editor has ended its tasks",
        "cursor editor has ended", 
        "cursor has stopped",
        "cursor not responding",
        "task completed",
        "cursor",
        "ended",
        "stopped",
        "completed"
    ]
    
    func start() {
        print("🚀 Starting monitoring...")
        print("📝 Watching for these patterns:")
        for pattern in searchPatterns {
            print("   - \(pattern)")
        }
        print("")
        
        // Monitor clipboard changes
        var lastClipboard = ""
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if !self.isRunning { return }
            
            // Check clipboard
            if let clipboard = NSPasteboard.general.string(forType: .string) {
                if clipboard != lastClipboard && !clipboard.isEmpty {
                    lastClipboard = clipboard
                    self.checkText(clipboard, source: "clipboard")
                }
            }
            
            // Check running applications
            self.checkRunningApps()
        }
        
        // Keep running
        RunLoop.main.run()
    }
    
    func stop() {
        isRunning = false
        print("🛑 Stopped monitoring")
    }
    
    private func checkText(_ text: String, source: String) {
        let lowercaseText = text.lowercased()
        
        for pattern in searchPatterns {
            if lowercaseText.contains(pattern.lowercased()) {
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
                print("🎯 DETECTED [\(source)] at \(timestamp):")
                print("   Pattern: \(pattern)")
                print("   Text: \(text.prefix(100))...")
                print("")
                
                // Show system notification using AppleScript (more reliable)
                showNotification(title: "Cursor Watch Alert", message: "Found '\(pattern)' in \(source)")
                break
            }
        }
    }
    
    private func checkRunningApps() {
        let workspace = NSWorkspace.shared
        let apps = workspace.runningApplications
        
        for app in apps {
            if let appName = app.localizedName?.lowercased() {
                if appName.contains("cursor") {
                    // Print Cursor app status (helpful for debugging)
                    if !app.isActive && app.isFinishedLaunching {
                        print("ℹ️  Cursor app detected: \(appName) (inactive)")
                    }
                }
            }
        }
    }
    
    private func showNotification(title: String, message: String) {
        // Use AppleScript for notifications (more compatible)
        let script = """
        display notification "\(message)" with title "\(title)" sound name "default"
        """
        
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]
        
        do {
            try task.run()
        } catch {
            print("⚠️  Could not show notification: \(error)")
        }
    }
}

// Handle Ctrl+C gracefully
var monitor: SimpleCursorWatch?

signal(SIGINT) { _ in
    print("\n🛑 Stopping Cursor Watch...")
    monitor?.stop()
    exit(0)
}

// Start monitoring
monitor = SimpleCursorWatch()
monitor?.start() 
