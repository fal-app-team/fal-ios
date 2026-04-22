import Foundation

@MainActor
class DreamViewModel: ObservableObject {
    @Published var interpretationResult: String = ""
    @Published var suggestion: String = ""
    @Published var themes: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func interpretDream(dreamText: String, symbols: [String]) async {
        guard let url = URL(string: "http://127.0.0.1:8080/api/dream/interpret") else {
            errorMessage = "Geçersiz URL"
            return
        }

        isLoading = true
        errorMessage = nil
        interpretationResult = ""
        suggestion = ""
        themes = []

        let requestBody = DreamInterpretRequest(
            dreamText: dreamText,
            symbols: symbols,
            userName: nil
        )

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            if let token = UserDefaults.standard.string(forKey: "jwtToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                print("JWT Token gönderildi:", token)
            } else {
                print("JWT Token bulunamadı")
            }

            request.timeoutInterval = 30

            let encodedBody = try JSONEncoder().encode(requestBody)
            request.httpBody = encodedBody

            print("=== DREAM REQUEST START ===")
            print("URL:", url.absoluteString)
            print("Dream Text:", dreamText)
            print("Symbols:", symbols)
            print("Request JSON:", String(data: encodedBody, encoding: .utf8) ?? "Body çevrilemedi")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Geçersiz sunucu cevabı"
                isLoading = false
                return
            }

            print("Status Code:", httpResponse.statusCode)
            print("Response Body:", String(data: data, encoding: .utf8) ?? "Boş response")

            guard 200...299 ~= httpResponse.statusCode else {
                let serverMessage = String(data: data, encoding: .utf8) ?? "Bilinmeyen hata"
                errorMessage = "Sunucu hatası (\(httpResponse.statusCode)): \(serverMessage)"
                isLoading = false
                return
            }

            let decoded = try JSONDecoder().decode(DreamInterpretResponse.self, from: data)
            interpretationResult = decoded.interpretation
            suggestion = decoded.suggestion
            themes = decoded.detectedThemes

            print("Decoded interpretation:", decoded.interpretation)
            print("=== DREAM REQUEST END ===")
        } catch {
            print("REQUEST ERROR:", error)
            errorMessage = "İstek hatası: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
