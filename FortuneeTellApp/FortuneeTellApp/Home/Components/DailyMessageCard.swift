import SwiftUI

struct DailyMessageCard: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text("Günün Mesajı")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(.label))

                Text("Bugün sezgilerine güven, iç sesin sana doğru yolu gösterecek.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.90, blue: 0.72),
                    Color(red: 0.95, green: 0.87, blue: 0.78)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

#Preview {
    DailyMessageCard()
        .padding()
}
