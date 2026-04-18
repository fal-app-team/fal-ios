import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("jwtToken") private var jwtToken = ""

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            Text("Profil")
                .font(.system(size: 28, weight: .bold))

            Button("Çıkış Yap") {
                do {
                    try Auth.auth().signOut()
                    jwtToken = ""
                    isLoggedIn = false
                    hasCompletedOnboarding = false
                } catch {
                    print("Çıkış yapılırken hata oluştu: \(error.localizedDescription)")
                }
            }
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.red)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 80)
    }
}

#Preview {
    ProfileView()
}
