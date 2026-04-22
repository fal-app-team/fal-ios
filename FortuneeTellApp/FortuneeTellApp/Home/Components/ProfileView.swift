import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    struct OnboardingProfileResponseDTO: Codable {
        let userId: Int
        let name: String?
        let email: String
        let birthDate: String?
        let gender: String?
        let relationshipStatus: String?
        let employementStatus: String?
        let onboardingCompleted: Bool
    }

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("jwtToken") private var jwtToken = ""

    @State private var profile: OnboardingProfileResponseDTO?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemGray6),
                    Color(red: 0.96, green: 0.93, blue: 0.97)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection

                    if isLoading {
                        loadingCard
                    } else if let errorMessage {
                        errorCard(message: errorMessage)
                    } else if let profile {
                        profileCard(profile: profile)
                    } else {
                        emptyCard
                    }

                    logoutButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 100)
            }
        }
        .task {
            await fetchProfile()
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Profil")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color(.label))

            Text("Onboarding bilgilerini görüntüle")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }

    private var loadingCard: some View {
        VStack(spacing: 14) {
            ProgressView()
                .scaleEffect(1.1)

            Text("Profil bilgileri yükleniyor...")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private func errorCard(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30))
                .foregroundStyle(.orange)

            Text("Bir hata oluştu")
                .font(.system(size: 20, weight: .bold))

            Text(message)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Tekrar Dene") {
                Task {
                    await fetchProfile()
                }
            }
            .font(.system(size: 16, weight: .semibold))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.purple.opacity(0.12))
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var emptyCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 34))
                .foregroundStyle(.gray)

            Text("Profil bilgisi bulunamadı")
                .font(.system(size: 20, weight: .bold))

            Text("Kullanıcı bilgileri şu anda getirilemedi.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private func profileCard(profile: OnboardingProfileResponseDTO) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            profileRow(title: "Ad Soyad", value: profile.name ?? "-")
            profileRow(title: "E-posta", value: profile.email)
            profileRow(title: "Doğum Tarihi", value: formatBirthDate(profile.birthDate))
            profileRow(title: "Cinsiyet", value: formatGender(profile.gender))
            profileRow(title: "İlişki Durumu", value: formatRelationship(profile.relationshipStatus))
            profileRow(title: "Çalışma Durumu", value: formatEmployment(profile.employementStatus))
            profileRow(
                title: "Onboarding Durumu",
                value: profile.onboardingCompleted ? "Tamamlandı" : "Tamamlanmadı"
            )
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }

    private func profileRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color(.label))

            Divider()
        }
    }

    private var logoutButton: some View {
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
        .font(.system(size: 18, weight: .semibold))
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    @MainActor
    private func fetchProfile() async {
        guard !jwtToken.isEmpty else {
            errorMessage = "JWT token bulunamadı."
            return
        }

        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "http://localhost:8080/api/onboarding/me") else {
            errorMessage = "Profil URL hatalı."
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Profile status code: \(httpResponse.statusCode)")
            }

            let decoded = try JSONDecoder().decode(OnboardingProfileResponseDTO.self, from: data)
            profile = decoded
        } catch {
            print("Profil çekme hatası: \(error.localizedDescription)")
            errorMessage = "Profil bilgileri alınamadı."
        }

        isLoading = false
    }

    private func formatBirthDate(_ value: String?) -> String {
        guard let value, !value.isEmpty else { return "-" }
        return value
    }

    private func formatGender(_ value: String?) -> String {
        switch value {
        case "FEMALE":
            return "Kadın"
        case "MALE":
            return "Erkek"
        case "OTHER":
            return "Diğer"
        default:
            return "-"
        }
    }

    private func formatRelationship(_ value: String?) -> String {
        switch value {
        case "SINGLE":
            return "Bekar"
        case "MARRIED":
            return "Evli"
        case "IN_RELATIONSHIP":
            return "İlişkisi var"
        case "COMPLICATED":
            return "Karmaşık"
        default:
            return "-"
        }
    }

    private func formatEmployment(_ value: String?) -> String {
        switch value {
        case "EMPLOYED":
            return "Çalışıyor"
        case "UNEMPLOYED":
            return "İş Arıyor"
        case "STUDENT":
            return "Öğrenci"
        case "RETIRED":
            return "Emekli"
        case "ENTREPRENEUR":
            return "Kendi işini yapıyor"
        default:
            return "-"
        }
    }
}

#Preview {
    ProfileView()
}
