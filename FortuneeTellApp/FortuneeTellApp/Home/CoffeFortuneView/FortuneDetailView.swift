import SwiftUI

struct FortuneDetailView: View {
    let item: FortuneHistoryItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Üst Kısım: Tür ve Tarih
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.type.displayName)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: item.type.gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text(formattedDate(item.date))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                    
                    // Senin Seçimin / Girişin (Kartlar veya Rüya Metni)
                    if let userInput = item.userInput, !userInput.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(item.type == .tarot ? "Seçtiğin Kartlar" : "Rüyan")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            Text(userInput)
                                .font(.system(size: 16))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    
                    // AI Yorumu
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Ruhani Yorum")
                        }
                        .font(.headline)
                        .foregroundStyle(.purple)
                        
                        Text(item.aiResponse ?? "Yorum henüz yüklenmedi.")
                            .font(.system(size: 17))
                            .lineSpacing(8)
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                    
                    Spacer(minLength: 40)
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        return formatter.string(from: date)
    }
}
