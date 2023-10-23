//
//  resendVerificationView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 22/10/2023.
//

import SwiftUI

struct ResendVerificationView: View {
    @EnvironmentObject var resendVerificationViewModel: ResendVerificationViewModel
    @EnvironmentObject var darkModeManager: DarkModeManager
    @Binding var showResendVerificationAlert: Bool
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    
    var body: some View {
        VStack {
            Text("Haven't received your account verification link?")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(Color.primary)
                .padding(.bottom, 20)
                .padding(.top, 30)

            TextField("Enter email", text: $resendVerificationViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.bottom, 15)
                .accentColor(AppColors.originalGreen)

            Button(action: {
                Task {
                    let result = await resendVerificationViewModel.resendVerification()
                    switch result {
                    case .success(_):
                        showResendVerificationAlert = true
                        alertTitle = "Success"
                        alertMessage = "A new link to verify your account has been sent to your email address"
                    case .failure(let error):
                        showResendVerificationAlert = true
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

struct ResendVerificationView_Previews: PreviewProvider {
    @State static var mockShowResendVerificationAlert: Bool = true
    @State static var mockAlertMessage: String = "Example Text"
    @State static var mockAlertTitle: String = "Example Title"
    
    static var previews: some View {
        ResendVerificationView(showResendVerificationAlert: $mockShowResendVerificationAlert, alertMessage: $mockAlertMessage, alertTitle: $mockAlertTitle)
    }
}
