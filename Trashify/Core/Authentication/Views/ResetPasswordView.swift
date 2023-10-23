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
            Text("Forgot password?")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(Color.primary)
                .padding(.bottom, 20)
                .padding(.top, 30)

            TextField("Enter email", text: $resetPasswordViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.bottom, 15)
                .accentColor(AppColors.originalGreen)

            Button(action: {
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
            }) {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width: 100, height: 40)
                    .background(AppColors.darkerGreen)
                    .cornerRadius(10.0)
            }
            .padding(.horizontal)

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
