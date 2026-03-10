
import SwiftUI

struct WelcomeStepView: View {

    @State private var showFortune = false

    var body: some View {

        VStack(spacing: 24) {

            Text("Hadi Başlayalım 🔮")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            Text("Artık falını yorumlamaya hazırız🪄")
                .foregroundStyle(.secondary)

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.3), .pink.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 220, height: 220)

                Image("Image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .offset(y: showFortune ? 0 : 200)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: showFortune)
            }

            Spacer()
        }
        .onAppear {
            showFortune = true
        }
    }
}
