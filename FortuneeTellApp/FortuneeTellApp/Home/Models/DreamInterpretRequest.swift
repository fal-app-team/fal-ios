import Foundation

struct DreamInterpretRequest: Codable {
    let dreamText: String
    let symbols: [String]
    let userName: String?
}
