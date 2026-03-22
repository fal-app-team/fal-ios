import SwiftUI

struct StatCardView: View {
    let totalFortunes: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Toplam Falın")
                    .foregroundColor(.white.opacity(0.8))

                Text("\(totalFortunes)")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "arrow.up.right")
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.purple, Color.pink],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
