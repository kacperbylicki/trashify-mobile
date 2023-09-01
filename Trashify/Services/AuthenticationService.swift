//
//  AuthenticationService.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import Foundation

enum AuthenticationError: Error {
    case custom(message: String)
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResult: Decodable {
    let accessToken: String?
    let refreshToken: String?
}

struct LoginResponse: Decodable {
    let data: LoginResult?
    let status: Int
    let error: [String?]?
}

struct LogoutResponse: Decodable {
    let status: Int
    let error: [String?]?
}

struct RegisterRequest: Codable {
    let email: String
    let username: String
    let password: String
    let confirmPassword: String
}

struct RegisterResponse: Decodable {
    let status: Int
    let error: [String?]?
}

class AuthenticationService {
    let baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
    
    func login(email: String, password: String) async throws -> (accessToken: String, refreshToken: String) {
        guard let url = URL(string: "\(baseURL)/login") else {
            throw AuthenticationError.custom(message: "URL is not correct")
        }
        
        let body = LoginRequest(email: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        guard let responseData = loginResponse.data, let accessToken = responseData.accessToken, let refreshToken = responseData.refreshToken else {
            throw AuthenticationError.custom(message: (loginResponse.error?.first ?? "Unknown Error") ?? "Unknown Error")
        }
        
        return (accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func logout(accessToken: String) async throws -> Void {
        guard let url = URL(string: "\(baseURL)/logout") else {
            throw AuthenticationError.custom(message: "URL is not correct")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let logoutResponse = try JSONDecoder().decode(LogoutResponse.self, from: data)
        
        guard logoutResponse.status == 200 else {
            throw AuthenticationError.custom(message: (logoutResponse.error?.first ?? "Unknown Error") ?? "Unknown Error")
        }
    }
    
    func register(email: String, username: String, password: String, confirmPassword: String) async throws -> Void {
        guard let url = URL(string: "\(baseURL)/register") else {
            throw AuthenticationError.custom(message: "URL is not correct")
        }
        
        let body = RegisterRequest(email: email, username: username, password: password, confirmPassword: confirmPassword)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
        
        guard registerResponse.status == 201 else {
            throw AuthenticationError.custom(message: (registerResponse.error?.first ?? "Unknown Error") ?? "Unknown Error")
        }
    }
}
