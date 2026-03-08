import SwiftUI

struct OptionCardButton: View {
    let title: String
    let isSelected: Bool
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: gradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.white
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(
                            isSelected ? Color.white.opacity(0.35) : Color.black.opacity(0.04),
                            lineWidth: isSelected ? 1.2 : 1
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(
                    color: .black.opacity(isSelected ? 0.14 : 0.08),
                    radius: isSelected ? 16 : 10,
                    x: 0,
                    y: isSelected ? 10 : 6
                )
                .scaleEffect(isSelected ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.20), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        OptionCardButton(
            title: "Kadın",
            isSelected: true,
            gradient: [.purple, .pink]
        ) {}

        OptionCardButton(
            title: "Erkek",
            isSelected: false,
            gradient: [.purple, .pink]
        ) {}
    }
    .padding()
}
