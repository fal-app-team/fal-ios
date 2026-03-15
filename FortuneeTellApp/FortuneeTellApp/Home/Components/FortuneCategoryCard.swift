import SwiftUI

struct FortuneCategoryCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradientColors: [Color]

    var body: some View {
        Button {
            print("\(title) seçildi")
        } label: {
            HStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)

                    Image(systemName: icon)
                        .font(.system(size: 36, weight: .medium))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 21, weight: .bold))
                        .foregroundStyle(Color(.label))

                    Text(subtitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(20)
            .background(Color.white.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
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
