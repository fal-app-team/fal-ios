import SwiftUI

enum FortuneType: String {
    case coffee = "Kahve Falı"
    case tarot = "Tarot Falı"
    case dream = "Rüya Yorumu"
    
    var icon: String {
        switch self {
        case .coffee:
            return "cup.and.saucer.fill"
        case .tarot:
            return "sparkles"
        case .dream:
            return "moon.stars.fill"
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .coffee:
            return [Color.orange, Color(red: 1.0, green: 0.55, blue: 0.0)]
        case .tarot:
            return [Color.purple, Color.pink]
        case .dream:
            return [Color.indigo, Color.purple]
        }
    }
}

struct FortuneHistoryItem: Identifiable {
    let id = UUID()
    let type: FortuneType
    let images: [UIImage]
    let date: Date
    let status: String
    let interpretation: String?
}

final class FortuneHistoryStore: ObservableObject {
    @Published var items: [FortuneHistoryItem] = []
    
    func addCoffeeFortune(images: [UIImage]) {
        let item = FortuneHistoryItem(
            type: .coffee,
            images: images,
            date: Date(),
            status: "Yorumlanıyor...",
            interpretation: "Falın yorumlanmak üzere gönderildi. Çok yakında sonuç burada görünecek."
        )
        
        items.insert(item, at: 0)
    }
    
    func addDreamFortune(
        interpretation: String,
        themes: [String],
        suggestion: String
    ) {
        let detailText: String
        
        if themes.isEmpty && suggestion.isEmpty {
            detailText = interpretation
        } else {
            detailText = """
            \(interpretation)

            Temalar: \(themes.joined(separator: ", "))

            Öneri: \(suggestion)
            """
        }
        
        let item = FortuneHistoryItem(
            type: .dream,
            images: [],
            date: Date(),
            status: "Tamamlandı",
            interpretation: detailText
        )
        
        items.insert(item, at: 0)
    }
    
    var coffeeCount: Int {
        items.filter { $0.type == .coffee }.count
    }
    
    var tarotCount: Int {
        items.filter { $0.type == .tarot }.count
    }
    
    var dreamCount: Int {
        items.filter { $0.type == .dream }.count
    }
    
    var totalCount: Int {
        items.count
    }
}
