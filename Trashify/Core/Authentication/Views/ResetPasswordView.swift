//
//  ForgotPasswordView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 22/10/2023.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var resetPasswordViewModel: ResetPasswordViewModel
    @EnvironmentObject var darkModeManager: DarkModeManager
    @Binding var showForgotPasswordAlert: Bool
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    
    var body: some View {
        VStack {
            // Email field
            HStack {
                TextField("Enter email", text: $resetPasswordViewModel.email).keyboardType(.emailAddress).autocapitalization(.none).frame(height: 50).padding(.horizontal, 20).overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.darkerGreen, lineWidth: 3)
                )
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 25)

            // Reset Password button
            Button("Reset Password") {
                Task {
                    let result = await resetPasswordViewModel.resetPassword()
                    switch result {
                    case .success(_):
                        showForgotPasswordAlert = true
                        alertTitle = "Success"
                        alertMessage = "A password reset link has been sent to your email address"
                    case .failure(let error):
                        showForgotPasswordAlert = true
                        alertTitle = "Error"
                        alertMessage = error.errorDescription ?? "Unknown Error"
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .fontWeight(.bold)
            .background(AppColors.darkerGreen)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 20)
            .padding(.horizontal)
            .shadow(color: AppColors.darkerGreen.opacity(0.2), radius: 10, x: 0, y: 10)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    @State static var mockShowForgotPasswordAlert: Bool = true
    @State static var mockAlertMessage: String = "Example Text"
    @State static var mockAlertTitle: String = "Example Title"
    
    static var previews: some View {
        ResetPasswordView(showForgotPasswordAlert: $mockShowForgotPasswordAlert, alertMessage: $mockAlertMessage, alertTitle: $mockAlertTitle)
    }
}
