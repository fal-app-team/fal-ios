import SwiftUI

struct TarotDetailView: View {
    @StateObject private var viewModel = TarotViewModel()
    @AppStorage("jwtToken") private var jwtToken = ""
    @Namespace private var cardAnimation

    @State private var deck: [TarotCard] = []
    @State private var selectedCards: [TarotCard] = []
    @State private var showFaces = false
    @State private var showInterpretation = false

    var body: some View {
        ZStack {
            // Mistik Arka Plan
            LinearGradient(
                colors: [
                    Color(red: 42/255, green: 10/255, blue: 99/255),
                    Color(red: 68/255, green: 20/255, blue: 140/255),
                    Color(red: 96/255, green: 36/255, blue: 170/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            StarsOverlay().ignoresSafeArea()
            
            VStack {
                Text("ÜÇ KART SEÇİN")
                    .font(.custom("Palatino-Bold", size: 28))
                    .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                    .padding(.top, 20)
                
                Text("İçinizden gelen sese kulak verin. \(selectedCards.count)/3 kart seçildi")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 30)
                
                // ÜST KISIM: SEÇİLEN KARTLAR
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        VStack(spacing: 10) {
                            Text(["GEÇMİŞ", "ŞİMDİ", "GELECEK"][index])
                                .font(.caption).fontWeight(.bold)
                                .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                                    .frame(width: 90, height: 140)
                                
                                if index < selectedCards.count {
                                    CardView(card: selectedCards[index], isFaceUp: viewModel.revealedCards[index])
                                        .matchedGeometryEffect(id: selectedCards[index].id, in: cardAnimation)
                                        .frame(width: 90, height: 140)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                // ALT KISIM: YORUM VEYA DESTE
                if showInterpretation {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "sparkles").foregroundColor(.yellow)
                                Text("Evren size mesajını gönderdi").font(.headline).foregroundColor(.yellow)
                            }
                            Text(viewModel.interpretation)
                                .foregroundColor(.white)
                                .lineSpacing(6)
                                .font(.system(size: 16))
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.yellow.opacity(0.3), lineWidth: 1))
                        .padding(.horizontal, 24)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                } else if viewModel.isLoading {
                    VStack(spacing: 15) {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .yellow)).scaleEffect(1.5)
                        Text("Kartların enerjisi çözümleniyor...").foregroundColor(.white.opacity(0.8))
                    }
                } else if let errorMsg = viewModel.errorMessage {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red).font(.largeTitle)
                        Text(errorMsg).font(.caption).foregroundColor(.red).padding()
                    }
                } else if selectedCards.count < 3 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: -45) {
                            ForEach(deck) { card in
                                if !selectedCards.contains(where: { $0.id == card.id }) {
                                    CardView(card: card, isFaceUp: false)
                                        .matchedGeometryEffect(id: card.id, in: cardAnimation)
                                        .frame(width: 100, height: 155)
                                        .rotationEffect(.degrees(Double.random(in: -4...4)))
                                        .onTapGesture { selectCard(card) }
                                }
                            }
                        }
                        .padding(.horizontal, 60)
                    }
                    .frame(height: 220)
                }
                Spacer()
            }
        }
        .onAppear { setupDeck() }
        .onChange(of: viewModel.cards) { newCards in
            if newCards.count == 3 {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    selectedCards = newCards
                    showFaces = true
                    showInterpretation = true
                }
            }
        }
    }

    private func setupDeck() {
        deck = (1...12).map { i in
            TarotCard(id: 1000 + i, name: "Bilinmeyen", nameShort: "", meaningUp: "", meaningRev: "", description: "", imageUrl: "")
        }
    }

    private func selectCard(_ card: TarotCard) {
        guard selectedCards.count < 3 else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            selectedCards.append(card)
        }
        if selectedCards.count == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                viewModel.drawCards(token: jwtToken)
            }
        }
    }
}

// MARK: - CardView
struct CardView: View {
    let card: TarotCard
    let isFaceUp: Bool
    
    var body: some View {
        ZStack {
            // KARTIN ARKASI
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(colors: [Color(red: 100/255, green: 20/255, blue: 160/255), Color(red: 60/255, green: 10/255, blue: 120/255)], startPoint: .top, endPoint: .bottom))
                .overlay(
                    Image(systemName: "moon")
                        .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.8))
                        .font(.largeTitle)
                )
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.4), lineWidth: 1.5))
                .opacity(isFaceUp ? 0 : 1)
      
            // KARTIN ÖNÜ
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    VStack {
                        Spacer()
                        if let imgUrlString = card.imageUrl,
                           let encodedUrlString = imgUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                           let url = URL(string: encodedUrlString) {
                            
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().aspectRatio(contentMode: .fit).padding(5)
                                    
                                case .failure(let error):
                                    // ATA BURADA YAKALANIYOR VE KARTA YAZDIRILIYOR
                                    VStack {
                                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                                        Text(error.localizedDescription)
                                            .font(.system(size: 8))
                                            .foregroundColor(.red)
                                            .multilineTextAlignment(.center)
                                            .padding(2)
                                    }
                                    let _ = print("RESİM HATASI (\(card.name)): \(error.localizedDescription)")
                                    
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            // Eğer backend'den imageUrl hiç gelmezse
                            VStack {
                                Image(systemName: "xmark.octagon").foregroundColor(.red)
                                Text("URL BOŞ").font(.system(size: 10)).foregroundColor(.red)
                            }
                        }
                      
                    
                        Spacer()
                        
                        Text(card.name)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(red: 68/255, green: 20/255, blue: 140/255))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                )
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.8), lineWidth: 2))
                .opacity(isFaceUp ? 1 : 0)
        }
        // Kartın genel dönme animasyonu
        .rotation3DEffect(
            Angle(degrees: isFaceUp ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}
