//
//  AuthModels.swift
//  FortuneeTellApp
//
//  Created by Deniz Metin on 16.03.2026.
//

import Foundation

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct VerifyCodeRequest: Codable {
    let email: String
    let code:String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}
struct AuthResponse: Codable {
    let token: String
    let message: String
}
struct MessageResponse: Codable {
    let message: String
}
