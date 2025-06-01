import SwiftUI

struct ContentView: View {
    @StateObject private var screenMonitor = ScreenMonitor()
    @State private var customSearchText = "cursor editor has ended its tasks"
    @State private var isMonitoring = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "eye.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title)
                
                Text("Cursor Watch")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top)
            
            // Status indicator
            HStack {
                Circle()
                    .fill(isMonitoring ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
                
                Text(isMonitoring ? "Monitoring Active" : "Monitoring Stopped")
                    .font(.headline)
                    .foregroundColor(isMonitoring ? .green : .gray)
            }
            
            Divider()
            
            // Search text configuration
            VStack(alignment: .leading, spacing: 10) {
                Text("Search Text:")
                    .font(.headline)
                
                TextField("Enter text to watch for...", text: $customSearchText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        updateSearchPatterns()
                    }
                
                Text("This text will be detected when it appears on screen")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Detection log
            VStack(alignment: .leading, spacing: 10) {
                Text("Recent Detections:")
                    .font(.headline)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(screenMonitor.detectionHistory.indices, id: \.self) { index in
                            let detection = screenMonitor.detectionHistory[index]
                            HStack {
                                Text(detection.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(detection.detectedText)
                                    .font(.footnote)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                        }
                    }
                }
                .frame(height: 150)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
            }
            
            Divider()
            
            // Controls
            HStack {
                Button(action: {
                    if isMonitoring {
                        stopMonitoring()
                    } else {
                        startMonitoring()
                    }
                }) {
                    HStack {
                        Image(systemName: isMonitoring ? "stop.circle.fill" : "play.circle.fill")
                        Text(isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(isMonitoring ? Color.red : Color.blue)
                    .cornerRadius(8)
                }
                
                Button("Clear Log") {
                    screenMonitor.clearHistory()
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 500)
        .onAppear {
            updateSearchPatterns()
        }
    }
    
    private func startMonitoring() {
        screenMonitor.startMonitoring()
        isMonitoring = true
    }
    
    private func stopMonitoring() {
        screenMonitor.stopMonitoring()
        isMonitoring = false
    }
    
    private func updateSearchPatterns() {
        var patterns = [customSearchText.lowercased()]
        
        // Add some default Cursor-related patterns
        patterns.append(contentsOf: [
            "cursor editor has ended",
            "cursor has stopped",
            "cursor not responding",
            "task completed"
        ])
        
        screenMonitor.updateSearchPatterns(patterns)
    }
} 
