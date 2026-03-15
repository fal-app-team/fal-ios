import SwiftUI

struct StatCardView: View {
    let totalFortunes: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Toplam Falın")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))

                Text("\(totalFortunes)")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.white)
            }

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.20))
                    .frame(width: 82, height: 82)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .padding(28)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.63, green: 0.17, blue: 0.95),
                    Color(red: 0.93, green: 0.00, blue: 0.47)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .purple.opacity(0.18), radius: 16, x: 0, y: 10)
    }
}

#Preview {
    StatCardView(totalFortunes: 0)
        .padding()
}
