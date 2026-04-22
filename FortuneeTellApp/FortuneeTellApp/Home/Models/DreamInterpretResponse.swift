import Foundation

struct DreamInterpretResponse: Codable {
    let interpretation: String
    let detectedThemes: [String]
    let suggestion: String
}
