import Foundation
import SwiftUI

class TarotViewModel: ObservableObject {
    @Published var cards: [TarotCard] = []
    @Published var interpretation: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Kartların dönme animasyonunu kontrol etmek için
    @Published var revealedCards: [Bool] = [false, false, false]
    
    func drawCards(token: String) {
        // Yeni fal çekildiğinde ekranı sıfırla
        self.cards = []
        self.interpretation = ""
        self.revealedCards = [false, false, false]
        self.isLoading = true
        self.errorMessage = nil
        
        TarotService.shared.drawCards(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.cards = response.cards
                    self?.interpretation = response.interpretation
                    self?.revealCardsSequentially()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Kartları aynı anda değil, yarım saniye arayla sırayla açmak için
    private func revealCardsSequentially() {
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    self.revealedCards[i] = true
                }
            }
        }
    }
}
