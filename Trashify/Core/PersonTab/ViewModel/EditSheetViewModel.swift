//
//  EditUserDataModel.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

class EditUserDataViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var errorMessage: String?
    @Published var updateSuccess: Bool = false
    
    private let authService = AuthenticationService()
    private var keychainHelper = KeychainHelper()
    
    // Load the access token from the keychain
    private var accessToken: String {
        keychainHelper.load("accessToken") ?? ""
    }
    
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
    
    func updateEmail() {
        if !validateEmail() {
            errorMessage = "Invalid email format."
            return
        }
        
        Task {
            do {
                try await authService.updateEmail(accessToken: accessToken, newEmail: email)
                updateSuccess = true
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func updateUsername() {
        if !validateUsername() {
            errorMessage = "Invalid username format. Must be between 3 to 20 characters long and contain only alphanumeric characters."
            return
        }
        
        Task {
            do {
                try await authService.updateUsername(accessToken: accessToken, newUsername: username)
                updateSuccess = true 
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
