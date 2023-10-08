//
//  UserDataViewModel.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

class UserDataViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    
    private var authService = AuthenticationService()
    private var keychainHelper = KeychainHelper()
    
    // Load the access token from the keychain
    private var accessToken: String {
        keychainHelper.load("accessToken") ?? ""
    }
    
    func fetchUserData() {
        Task {
            do {
                let userDetails = try await authService.fetchCurrentUserDetails(accessToken: accessToken)
                DispatchQueue.main.async {
                    self.email = userDetails.email
                    self.username = userDetails.username
                }
                
                print(username)
            } catch let error as AuthenticationError {
                print("Error fetching user data: \(error)")
            } catch {
                print("Unknown error while fetching user data.")
            }
        }
    }
}
