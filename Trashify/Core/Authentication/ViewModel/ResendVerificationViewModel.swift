//
//  SwiftUIView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 22/10/2023.
//

import SwiftUI

enum ResendVerificationError: LocalizedError {
    case passwordResetError(String)
    case invalidResetEmail
    
    var errorDescription: String? {
        switch self {
        case .passwordResetError(let error):
            return error
        case .invalidResetEmail:
            return "Invalid email address for password reset"
        }
    }
}

class ResendVerificationViewModel: ObservableObject {
    @Published var email: String = ""
    
    private let authenticationService = AuthenticationService()

    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func resendVerification() async -> Result<Void, ResendVerificationError> {
        if !validateEmail() {
            return .failure(.invalidResetEmail)
        }

        do {
            try await authenticationService.resendVerification(email: email)
            return .success(())
        } catch AuthenticationError.custom(let errorMessage) {
            return .failure(.passwordResetError(errorMessage))
        } catch {
            return .failure(.passwordResetError(error.localizedDescription))
        }
    }
}
