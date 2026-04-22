import Foundation

class DreamViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var lastInterpretation: String? = nil

    func interpretDream(dreamText: String, token: String) async -> Bool {
        // UI güncellemelerini ana thread'de yapıyoruz
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        // Backend URL'ini kontrol et (localhost:8080 kullandığını varsayıyorum)
        guard let url = URL(string: "http://localhost:8080/api/dream/interpret") else {
            await MainActor.run {
                self.errorMessage = "Sunucu adresi hatalı."
                self.isLoading = false
            }
            return false
        }
        
        let body: [String: Any] = ["dreamText": dreamText]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Backend'den gelen JSON'u parse ediyoruz
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let interpretation = json["interpretation"] as? String {
                    
                    await MainActor.run {
                        self.lastInterpretation = interpretation
                        self.isLoading = false
                    }
                    return true
                }
            }
            
            await MainActor.run {
                self.errorMessage = "Rüya yorumu alınamadı."
                self.isLoading = false
            }
            return false
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Bağlantı hatası: \(error.localizedDescription)"
                self.isLoading = false
            }
            return false
        }
    }
}
