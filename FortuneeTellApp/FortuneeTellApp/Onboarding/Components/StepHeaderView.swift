import SwiftUI

struct StepHeaderView: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(
                        LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 72, height: 72)
                    .shadow(color: .black.opacity(0.14), radius: 16, x: 0, y: 10)

                Image(systemName: icon)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
            }

            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.top, 32)
    }
}

#Preview {
    StepHeaderView(
        icon: "calendar",
        title: "Doğum Tarihin",
        subtitle: "Falında kullanmak için doğum tarihini gir",
        gradient: [.purple, .pink]
    )
}
