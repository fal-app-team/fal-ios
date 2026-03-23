import Foundation
import SwiftUI

class AuthService {
    
    static let shared = AuthService()
    
    private let baseURL = "http://127.0.0.1:8080/api/auth"
    
    private init() {}
    
    func register(request: RegisterRequest, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register/request") else { return }
        postRequest(url: url, body: request, completion: completion)
    }
    
    func verifyCode(request: VerifyCodeRequest, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register/verify") else { return }
        postRequest(url: url, body: request, completion: completion)
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else { return }
        postRequest(url: url, body: request, completion: completion)
    }
    
    // Generic POST function
    private func postRequest<T: Codable, U: Codable>(url: URL, body: T, completion: @escaping (Result<U, Error>) -> Void) {
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "POST"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONEncoder().encode(body)
            requestURL.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(U.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
