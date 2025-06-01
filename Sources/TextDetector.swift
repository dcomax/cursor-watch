import Vision
import CoreImage
import Foundation

class TextDetector {
    var onTextDetected: ((String) -> Void)?
    private var searchPatterns: [String] = []
    
    func updateSearchPatterns(_ patterns: [String]) {
        searchPatterns = patterns
    }
    
    func detectText(in image: CIImage) async {
        let request = VNRecognizeTextRequest { [weak self] request, error in
            if let error = error {
                print("Text recognition error: \(error)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            self?.processTextObservations(observations)
        }
        
        // Configure the request for better accuracy
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        // Specify languages if needed (English by default)
        request.recognitionLanguages = ["en-US"]
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
        }
    }
    
    private func processTextObservations(_ observations: [VNRecognizedTextObservation]) {
        var detectedTexts: [String] = []
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else {
                continue
            }
            
            let recognizedText = topCandidate.string
            detectedTexts.append(recognizedText)
        }
        
        // Combine all detected text into one string
        let fullText = detectedTexts.joined(separator: " ")
        
        // Check if any search patterns match
        if !fullText.isEmpty && containsSearchPattern(fullText) {
            onTextDetected?(fullText)
        }
    }
    
    private func containsSearchPattern(_ text: String) -> Bool {
        let lowercaseText = text.lowercased()
        
        for pattern in searchPatterns {
            if lowercaseText.contains(pattern.lowercased()) {
                return true
            }
        }
        
        return false
    }
} 
