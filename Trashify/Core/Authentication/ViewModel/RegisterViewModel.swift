//
//  RegisterViewModel.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct CustomRegistrationError: Error {
    var errorMessage: String
}

enum RegisterError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case passwordsDontMatch
    case registrationError(String)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email address"
        case .invalidPassword:
            return "Invalid password. It should be at least 6 characters long and contain at least one number and one special character."
        case .passwordsDontMatch:
            return "Passwords don't match."
        case .registrationError(let error):
            return error
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
}

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    private let authenticationService = AuthenticationService()
    
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func validateUsername() -> Bool {
        let usernameRegex = "^[a-zA-Z0-9]{3,20}$"
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernameTest.evaluate(with: username)
    }
    
    private func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    private func validatePasswordConfirmation() -> Bool {
        password == confirmPassword
    }
    
    func register() async -> Result<Void, RegisterError> {
        if !validateEmail() {
            return .failure(.invalidEmail)
        }
        if !validatePassword() {
            return .failure(.invalidPassword)
        }
        if !validatePasswordConfirmation() {
            return .failure(.passwordsDontMatch)
        }
        
        do {
            try await authenticationService.register(email: email, username: username, password: password, confirmPassword: confirmPassword)
            return .success(())
        } catch AuthenticationError.custom(let errorMessage) {
            return .failure(.registrationError(errorMessage))
        } catch {
            return .failure(.unknownError(error))
        }
    }
}
