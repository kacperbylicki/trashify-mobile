//
//  LoginViewModel.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct CustomLoginError: Error {
    var errorMessage: String
}

enum LoginError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case loginError(String)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email address"
        case .invalidPassword:
            return "Invalid password. It should be at least 6 characters long and contain at least one number and one special character."
        case .loginError(let error):
            return error
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
}

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authenticationStatus: Bool = false
    
    private let keychainHelper = KeychainHelper()
    private let authenticationService = AuthenticationService()
    
    var isAuthenticated: Bool {
        keychainHelper.load("accessToken") != nil
    }
    
    init() {
        authenticationStatus = isAuthenticated
    }
    
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    func login() async -> Result<Void, LoginError> {
        if !validateEmail() {
            return .failure(.invalidEmail)
        }
        if !validatePassword() {
            return .failure(.invalidPassword)
        }
        
        do {
            let tokens = try await authenticationService.login(email: email, password: password)
            keychainHelper.save("accessToken", data: tokens.accessToken)
            keychainHelper.save("refreshToken", data: tokens.refreshToken)
            authenticationStatus = true
            return .success(())
        } catch AuthenticationError.custom(let errorMessage) {
            authenticationStatus = false
            return .failure(.loginError(errorMessage))
        } catch {
            authenticationStatus = false
            return .failure(.unknownError(error))
        }
    }
    
    func logout() async -> Void {
        let accessToken = keychainHelper.load("accessToken") ?? ""
        
        do {
            try await authenticationService.logout(accessToken: accessToken)
            keychainHelper.delete("accessToken")
            keychainHelper.delete("refreshToken")
            authenticationStatus = false
        } catch {
            print(error)
            authenticationStatus = true
        }
    }
}
