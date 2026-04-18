import SwiftUI

struct FortuneDetailView: View {
    let item: FortuneHistoryItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text(item.type.rawValue)
                        .font(.system(size: 30, weight: .bold))
                    
                    Text(formattedDate(item.date))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    if !item.images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(item.images.enumerated()), id: \.offset) { _, image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180, height: 180)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 22))
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Durum")
                            .font(.headline)
                        Text(item.status)
                            .foregroundStyle(.purple)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Yorum")
                            .font(.headline)
                        
                        Text(item.interpretation ?? "Henüz yorum eklenmedi.")
                            .font(.system(size: 16))
                            .foregroundStyle(.primary)
                            .lineSpacing(5)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Fal Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
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
