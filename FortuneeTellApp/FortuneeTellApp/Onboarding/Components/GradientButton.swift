import SwiftUI

struct GradientButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title).font(.headline).foregroundStyle(.white)
                Image(systemName: "arrow.right").foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical, 16)
            .background(
                LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing)
                    .opacity(isEnabled ? 1 : 0.35)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .disabled(!isEnabled)
    }
}
