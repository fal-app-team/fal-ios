import SwiftUI

struct FortuneCategoryCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradientColors: [Color]

    var body: some View {
        HStack(spacing: 18) {
                    ZStack {
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 22))

                        Image(systemName: icon)
                            .font(.system(size: 36, weight: .medium))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(size: 21, weight: .semibold))
                            .foregroundColor(.blue)

                        Text(subtitle)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
                .contentShape(Rectangle())
    }
}

#Preview {
    FortuneCategoryCard(
        title: "Kahve Falı",
        subtitle: "Fincanından geleceğini oku",
        icon: "cup.and.saucer.fill",
        gradientColors: [.orange, .pink]
    )
    .padding()
}
