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
        // 1) 2026-04-28T10:04:12.123Z
        let isoWithFraction = ISO8601DateFormatter()
        isoWithFraction.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // 2) 2026-04-28T10:04:12Z
        let isoWithoutFraction = ISO8601DateFormatter()
        isoWithoutFraction.formatOptions = [.withInternetDateTime]

        // 3) 2026-04-28T10:04:12.123456
        let backendFormatterWithMicroseconds = DateFormatter()
        backendFormatterWithMicroseconds.locale = Locale(identifier: "en_US_POSIX")
        backendFormatterWithMicroseconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        // 4) 2026-04-28T10:04:12.123
        let backendFormatterWithMillis = DateFormatter()
        backendFormatterWithMillis.locale = Locale(identifier: "en_US_POSIX")
        backendFormatterWithMillis.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        // 5) 2026-04-28T10:04:12
        let backendFormatterWithoutMillis = DateFormatter()
        backendFormatterWithoutMillis.locale = Locale(identifier: "en_US_POSIX")
        backendFormatterWithoutMillis.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return isoWithFraction.date(from: createdAt)
            ?? isoWithoutFraction.date(from: createdAt)
            ?? backendFormatterWithMicroseconds.date(from: createdAt)
            ?? backendFormatterWithMillis.date(from: createdAt)
            ?? backendFormatterWithoutMillis.date(from: createdAt)
            ?? Date()
    }}

final class FortuneHistoryStore: ObservableObject {
    @Published var items: [FortuneHistoryItem] = []
    @Published var isLoading: Bool = false
    
    // Verileri Backend'den Çeken Fonksiyon
    func fetchHistory(token: String) {
        guard let url = URL(string: "http://127.0.0.1:8080/api/fortunes/history") else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                print("History fetch error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("History response boş")
                return
            }
            
            do {
                let backendItems = try JSONDecoder().decode([FortuneHistoryItem].self, from: data)
        
                
                DispatchQueue.main.async {
                    let localItems = self.items.filter { localItem in
                        localItem.id < 0
                    }
                    
                    let mergedItems = localItems + backendItems
                    
                    self.items = mergedItems.sorted {
                        $0.date > $1.date
                    }
                    
                    print("HISTORY COUNT:", self.items.count)
                }
            } catch {
                print("JSON Çözme Hatası:", error)
                print("Raw response:", String(data: data, encoding: .utf8) ?? "okunamadı")
            }
        }.resume()
    }
    func addLocalCoffeeFortune() {
        let item = FortuneHistoryItem(
            id: -Int(Date().timeIntervalSince1970),
            type: .coffee,
            userInput: "Fincan İçi, Sağ Açı ve Sol Açı fotoğrafları yüklendi.",
            aiResponse: "Kahve falın yorumlanmak üzere alındı. Yapay zeka modeli bağlandığında gerçek yorum burada görünecek.",
            createdAt: ISO8601DateFormatter().string(from: Date())
        )

        items.insert(item, at: 0)
    }
    func addOrUpdate(_ item: FortuneHistoryItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.insert(item, at: 0)
        }

        items.sort { $0.date > $1.date }
    }
    
    var coffeeCount: Int { items.filter { $0.type == .coffee }.count }
    var tarotCount: Int { items.filter { $0.type == .tarot }.count }
    var dreamCount: Int { items.filter { $0.type == .dream }.count }
    var totalCount: Int { items.count }
}
