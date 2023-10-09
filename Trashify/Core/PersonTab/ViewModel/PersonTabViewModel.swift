//
//  PersonTabViewModel.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 08/10/2023.
//

import SwiftUI

class PersonTabViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var newEmail: String = ""
    @Published var newUsername: String = ""
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
        return emailTest.evaluate(with: newEmail)
    }
    
    private func validateUsername() -> Bool {
        let usernameRegex = "^[a-zA-Z0-9]{6,64}$"
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernameTest.evaluate(with: newUsername)
    }
    
    func updateEmail() {
        if !validateEmail() {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid email format."
            }
            return
        }
        
        Task {
            do {
                self.errorMessage = ""
                try await authService.updateEmail(accessToken: accessToken, newEmail: newEmail)
                DispatchQueue.main.async {
                    self.updateSuccess = true
                }
                fetchUserData()
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateUsername() {
        if !validateUsername() {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid username format. Must be between 6 to 64 characters long and contain only alphanumeric characters."
            }
            return
        }
        
        Task {
            do {
                self.errorMessage = ""
                try await authService.updateUsername(accessToken: accessToken, newUsername: newUsername)
                DispatchQueue.main.async {
                    self.updateSuccess = true
                }
                fetchUserData()
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchUserData() {
        Task {
            do {
                let userDetails = try await authService.fetchCurrentUserDetails(accessToken: accessToken)
                DispatchQueue.main.async {
                    self.email = userDetails.email
                    self.username = userDetails.username
                }
            } catch let error as AuthenticationError {
                print("Error fetching user data: \(error)")
            } catch {
                print("Unknown error while fetching user data.")
            }
        }
    }
}
