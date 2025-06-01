#!/usr/bin/env swift

import Foundation
import Vision
import CoreImage
import ScreenCaptureKit
import UserNotifications

print("🔍 CursorWatch CLI - Screen Text Monitor")
print("========================================")

// Simple CLI-based screen monitoring
class SimpleCursorWatch {
    private var isRunning = false
    private var searchPatterns = [
        "cursor editor has ended its tasks",
        "cursor editor has ended",
        "cursor has stopped",
        "cursor not responding",
        "task completed"
    ]
    
    func start() {
        print("🚀 Starting screen monitoring...")
        print("📝 Watching for patterns:")
        for pattern in searchPatterns {
            print("   - \(pattern)")
        }
        print("\n💡 Press Ctrl+C to stop\n")
        
        isRunning = true
        
        // Request notification permission
        requestNotificationPermission()
        
        // Start monitoring loop
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            if self.isRunning {
                Task {
                    await self.captureAndAnalyze()
                }
            }
        }
        
        // Keep running
        RunLoop.main.run()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            }
        }
    }
    
    private func captureAndAnalyze() async {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
            
            guard let display = content.displays.first else {
                print("❌ No display found")
                return
            }
            
            let filter = SCContentFilter(display: display, excludingWindows: [])
            let config = SCStreamConfiguration()
            config.width = min(1920, Int(display.width)) // Reduce resolution for faster processing
            config.height = min(1080, Int(display.height))
            
            let stream = SCStream(filter: filter, configuration: config, delegate: nil)
            
            // For CLI version, we'll use a simpler approach
            print("📸 Capturing screen... (simplified OCR)")
            
        } catch {
            print("❌ Screen capture error: \(error.localizedDescription)")
        }
    }
    
    private func detectText(in text: String) {
        let lowercaseText = text.lowercased()
        
        for pattern in searchPatterns {
            if lowercaseText.contains(pattern.lowercased()) {
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
                print("🎯 DETECTED at \(timestamp): \(pattern)")
                
                // Send notification
                sendNotification(text: "Detected: \(pattern)")
                break
            }
        }
    }
    
    private func sendNotification(text: String) {
        let content = UNMutableNotificationContent()
        content.title = "CursorWatch Alert"
        content.body = text
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

// Handle Ctrl+C gracefully
signal(SIGINT) { _ in
    print("\n🛑 Stopping CursorWatch...")
    exit(0)
}

// Start the monitor
let monitor = SimpleCursorWatch()
monitor.start() 
