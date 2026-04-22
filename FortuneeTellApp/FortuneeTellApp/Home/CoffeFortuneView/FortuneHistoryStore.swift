import SwiftUI
import Foundation

enum FortuneType: String, Codable {
    case coffee = "COFFEE"
    case tarot = "TAROT"
    case dream = "DREAM"
    
    var displayName: String {
        switch self {
        case .coffee: return "Kahve Falı"
        case .tarot: return "Tarot Falı"
        case .dream: return "Rüya Yorumu"
        }
    }
    
    var icon: String {
        switch self {
        case .coffee: return "cup.and.saucer.fill"
        case .tarot: return "sparkles"
        case .dream: return "moon.stars.fill"
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .coffee: return [Color.orange, Color(red: 1.0, green: 0.55, blue: 0.0)]
        case .tarot: return [Color.purple, Color.pink]
        case .dream: return [Color.indigo, Color.purple]
        }
    }
}

// Backend'deki FortuneResult nesnesiyle birebir uyumlu model
struct FortuneHistoryItem: Identifiable, Codable {
    let id: Int
    let type: FortuneType
    let userInput: String?
    let aiResponse: String?
    let createdAt: String // Backend'den gelen tarih stringi
    
    // UI'da kullanmak için Date objesine çeviriyoruz
    var date: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: createdAt) ?? Date()
    }
}

final class FortuneHistoryStore: ObservableObject {
    @Published var items: [FortuneHistoryItem] = []
    @Published var isLoading: Bool = false
    
    // Verileri Backend'den Çeken Fonksiyon
    func fetchHistory(token: String) {
        guard let url = URL(string: "http://127.0.0.1:8080/api/fortunes/history") else { return }
        
        self.isLoading = true
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { self.isLoading = false }
            
            if let data = data {
                do {
                    let decodedItems = try JSONDecoder().decode([FortuneHistoryItem].self, from: data)
                    DispatchQueue.main.async {
                        self.items = decodedItems
                    }
                } catch {
                    print("JSON Çözme Hatası: \(error)")
                }
            }
        }.resume()
    }
    
    var coffeeCount: Int { items.filter { $0.type == .coffee }.count }
    var tarotCount: Int { items.filter { $0.type == .tarot }.count }
    var dreamCount: Int { items.filter { $0.type == .dream }.count }
    var totalCount: Int { items.count }
}
