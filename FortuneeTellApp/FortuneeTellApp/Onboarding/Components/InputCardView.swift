import SwiftUI

struct InputCardView<Content: View>: View {
    let label: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            content
        }
        .padding(16)
        .background(Color.white.opacity(0.60))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
        .padding(.horizontal, 20)
    }
}
