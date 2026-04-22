import Foundation


struct TarotCard: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let nameShort: String?
    let meaningUp: String?
    let meaningRev: String?
    let description: String?
    let imageUrl: String?
    let reversed: Bool
}

struct TarotReadingResponse: Codable {
    let cards: [TarotCard]
    let interpretation: String
}
