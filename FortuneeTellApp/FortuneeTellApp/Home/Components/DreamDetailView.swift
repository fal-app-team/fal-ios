import SwiftUI

struct DreamDetailView: View {
    @EnvironmentObject var historyStore: FortuneHistoryStore
    @Binding var selectedTab: TabItem
    @AppStorage("jwtToken") private var jwtToken = ""
    
    @State private var interpretationResult: String? = nil
    @State private var dreamText: String = ""
    @StateObject private var viewModel = DreamViewModel()

    var body: some View {
        ZStack {
            // Arka plan rengi
            Color(red: 0.96, green: 0.93, blue: 0.96)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    headerSection
                    
                    inputCard
                    
                    interpretButton
                    
                    // AI'dan cevap geldiyse burada gösteriyoruz
                    if let result = interpretationResult {
                        interpretationCard(result: result)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .opacity
                            ))
                            .padding(.bottom, 40)
                    }
                    
                    if viewModel.isLoading || viewModel.errorMessage != nil {
                        resultStatusSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .navigationTitle("Rüya Yorumu")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Arayüz Bileşenleri
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Rüya Tabiri")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))

            Text("Bilinçaltının gizemli kapılarını arala")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rüyanı Yaz")
                .font(.system(size: 18, weight: .semibold))
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.8))
                
                if dreamText.isEmpty {
                    Text("Gördüğün rüyayı tüm detaylarıyla buraya yaz...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                }

                TextEditor(text: $dreamText)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .frame(height: 200)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    private var interpretButton: some View {
        Button {
            Task {
                await interpretAndShow()
            }
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Image(systemName: "moon.stars.fill")
                    Text("Rüyamı Yorumla")
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(dreamText.count < 10 ? Color.gray : Color.indigo)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .disabled(dreamText.count < 10 || viewModel.isLoading)
    }

    private var resultStatusSection: some View {
        VStack {
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func interpretationCard(result: String) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Rüya Analizi")
                    .font(.headline)
                    .foregroundColor(.indigo)
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundColor(.indigo)
            }
            
            Divider()
            
            Text(LocalizedStringKey(result))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .lineSpacing(6)
            }
        
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 8)
    }

    // MARK: - İş Mantığı
    @MainActor
    private func interpretAndShow() async {
        guard !dreamText.isEmpty else { return }
        
        // Klavyeyi kapat
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        // Eski sonucu temizle
        self.interpretationResult = nil
        
        let success = await viewModel.interpretDream(dreamText: dreamText, token: jwtToken)
        
        if success {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.interpretationResult = viewModel.lastInterpretation
            }
        }
    }
}
