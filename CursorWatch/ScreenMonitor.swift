import SwiftUI
import ScreenCaptureKit
import Combine
import UserNotifications

struct Detection: Identifiable {
    let id = UUID()
    let timestamp: Date
    let detectedText: String
}

@MainActor
class ScreenMonitor: ObservableObject {
    @Published var detectionHistory: [Detection] = []
    @Published var isMonitoring = false
    
    private var textDetector = TextDetector()
    private var captureEngine: SCStreamEngine?
    private var searchPatterns: [String] = []
    private var monitoringTimer: Timer?
    
    init() {
        textDetector.onTextDetected = { [weak self] detectedText in
            Task { @MainActor in
                self?.handleTextDetection(detectedText)
            }
        }
    }
    
    func updateSearchPatterns(_ patterns: [String]) {
        searchPatterns = patterns
        textDetector.updateSearchPatterns(patterns)
    }
    
    func startMonitoring() {
        Task {
            await requestScreenCapturePermission()
            await startScreenCapture()
            isMonitoring = true
        }
    }
    
    func stopMonitoring() {
        stopScreenCapture()
        isMonitoring = false
    }
    
    func clearHistory() {
        detectionHistory.removeAll()
    }
    
    private func requestScreenCapturePermission() async {
        do {
            // Request screen recording permission
            let _ = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        } catch {
            print("Failed to request screen capture permission: \(error)")
        }
    }
    
    private func startScreenCapture() async {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
            
            guard let display = content.displays.first else {
                print("No displays found")
                return
            }
            
            let filter = SCContentFilter(display: display, excludingWindows: [])
            
            let configuration = SCStreamConfiguration()
            configuration.width = Int(display.width)
            configuration.height = Int(display.height)
            configuration.minimumFrameInterval = CMTime(value: 1, timescale: 2) // 2 FPS to reduce CPU usage
            configuration.queueDepth = 5
            
            let stream = SCStream(filter: filter, configuration: configuration, delegate: nil)
            
            // Start periodic screenshot capture
            startPeriodicCapture(with: stream)
            
        } catch {
            print("Failed to start screen capture: \(error)")
        }
    }
    
    private func startPeriodicCapture(with stream: SCStream) {
        // Take a screenshot every 2 seconds
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task {
                await self?.captureScreenshot(with: stream)
            }
        }
    }
    
    private func captureScreenshot(with stream: SCStream) async {
        do {
            let sampleBuffer = try await stream.captureSampleBuffer(type: .screen)
            
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                let ciImage = CIImage(cvPixelBuffer: imageBuffer)
                
                await textDetector.detectText(in: ciImage)
            }
        } catch {
            print("Failed to capture screenshot: \(error)")
        }
    }
    
    private func stopScreenCapture() {
        monitoringTimer?.invalidate()
        monitoringTimer = nil
        captureEngine = nil
    }
    
    private func handleTextDetection(_ detectedText: String) {
        // Check if any of our search patterns match
        let lowercaseText = detectedText.lowercased()
        
        for pattern in searchPatterns {
            if lowercaseText.contains(pattern) {
                let detection = Detection(timestamp: Date(), detectedText: detectedText)
                detectionHistory.insert(detection, at: 0)
                
                // Limit history to 50 items
                if detectionHistory.count > 50 {
                    detectionHistory.removeLast()
                }
                
                // Send notification
                sendNotification(for: detection)
                break
            }
        }
    }
    
    private func sendNotification(for detection: Detection) {
        let content = UNMutableNotificationContent()
        content.title = "Cursor Watch Alert"
        content.body = "Detected: \(detection.detectedText)"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(
            identifier: detection.id.uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error)")
            }
        }
    }
} 
