//
//  LoginView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var loginResult: Result<Void, LoginError>?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            // Header
            VStack(alignment: .leading) {
                Text("Trashify Welcomes You Back 🌱")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Together, let's keep making a difference!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 15)
            
            // Email field
            HStack {
                Text("Email")
                    .font(.headline)
            }
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding(.horizontal)
            HStack {
                TextField("Enter email", text: $loginViewModel.email).keyboardType(.emailAddress).autocapitalization(.none).frame(height: 50).padding(.horizontal, 20).overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.darkerGreen, lineWidth: 3)
                )
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Password field
            HStack {
                Text("Password")
                    .font(.headline)
            }
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding(.horizontal)
            HStack {
                SecureField("Enter password", text: $loginViewModel.password).autocapitalization(.none).frame(height: 50).padding(.horizontal, 20).overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.darkerGreen, lineWidth: 3)
                )
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Login button
            Button("Login") {
                Task {
                    let result = await loginViewModel.login()
                    switch result {
                    case .success(_):
                        isLoggedIn = true
                    case .failure(let error):
                        if !isLoggedIn {
                            showAlert = true
                            alertMessage = error.errorDescription ?? "Unknown Error"
                        }
                    }
                    loginResult = result
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"), action: {
                            showAlert = false
                        })
                )
            }
        })
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(.top, 25)
        .navigationBarHidden(true)
        
        // Registration navigation footer
        VStack(alignment: .trailing) {
            HStack(alignment: .center) {
                Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))

                NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                    Text("Register")
                            .foregroundColor(AppColors.darkerGreen)
                            .font(.system(size: 15))
                }
            }
            .padding(.bottom, 20)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static private var isLoggedIn = false
    
    static var previews: some View {
        LoginView(isLoggedIn: $isLoggedIn)
    }
}

