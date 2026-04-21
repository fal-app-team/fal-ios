import Foundation

class TarotService {
    
    static let shared = TarotService()

    private let baseURL = "http://127.0.0.1:8080/api/tarot"
    
    private init() {}
    
    func drawCards(token: String, completion: @escaping (Result<TarotReadingResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/draw") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Token'ı Authorization header'ına ekliyoruz
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print(" İSTEK ATILIYOR: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            //  İstek sunucuya hiç gidemedi
            if let error = error {
                print(" AĞ HATASI (Sunucuya ulaşılamadı): \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // İstek sunucuya gitti ve bir cevap döndü 
            if let httpResponse = response as? HTTPURLResponse {
                print(" BACKEND'DEN GELEN CEVAP KODU: \(httpResponse.statusCode)")
                
                if !(200...299).contains(httpResponse.statusCode) {
                    let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Sunucu hatası: \(httpResponse.statusCode)"])
                    DispatchQueue.main.async {
                        completion(.failure(statusCodeError))
                    }
                    return
                }
            }
            
            guard let data = data else { return }
            if let rawJson = String(data: data, encoding: .utf8) {
                            print("BACKEND'DEN GELEN SAF JSON: \(rawJson)")
                        }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TarotReadingResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print(" JSON ÇÖZÜMLEME HATASI: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
