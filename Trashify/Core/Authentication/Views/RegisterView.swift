//
//  RegisterView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct RegisterView: View {
    @Binding var isLoggedIn: Bool
    @StateObject private var registerViewModel = RegisterViewModel()
    @State private var registerResult: Result<Void, RegisterError>?
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            // Header
            VStack(alignment: .leading) {
                Text("Get Started with Trashify 🌱")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Be a part of our green revolution!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 15)
            
            // Username field
            HStack {
                Text("Username")
                    .font(.headline)
            }
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding(.horizontal)
            HStack {
                TextField("Enter username", text: $registerViewModel.username).autocapitalization(.none).frame(height: 50).padding(.horizontal, 20).overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.darkerGreen, lineWidth: 3)
                )
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Email field
            HStack {
                Text("Email Address")
                    .font(.headline)
            }
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding(.horizontal)
            HStack {
                TextField("Enter email", text: $registerViewModel.email).keyboardType(.emailAddress).autocapitalization(.none).frame(height: 50).padding(.horizontal, 20).overlay(
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
                SecureField("Enter password", text: $registerViewModel.password).autocapitalization(.none).frame(height: 50).padding(.horizontal, 20).overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.darkerGreen, lineWidth: 3)
                )
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Password confirmation field
            HStack {
                Text("Confirm Password")
                    .font(.headline)
            }
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding(.horizontal)
            HStack {
                SecureField("Enter password confirmation", text: $registerViewModel.confirmPassword).autocapitalization(.none).frame(height: 50).padding(.horizontal, 20).overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.darkerGreen, lineWidth: 3)
                )
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Register button
            Button("Register") {
                Task {
                    let result = await registerViewModel.register()
                    showAlert = true
                    registerResult = result
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
                switch registerResult {
                    case .failure(let error):
                        return Alert(title: Text("Error"), message: Text(error.errorDescription ?? "Unknown Error"), dismissButton: .default(Text("OK")))
                    default:
                        return Alert(title: Text("Success"), message: Text("Please check your email to confirm registration."), dismissButton: .default(Text("OK")))
                }
            }
        })
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(.top, 25)
        .navigationBarHidden(true)
        
        // Login navigation footer
        VStack(alignment: .trailing) {
            HStack(alignment: .center) {
                Text("Already have an account?")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))

                NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                    Text("Login")
                            .foregroundColor(AppColors.darkerGreen)
                            .font(.system(size: 15))
                }
            }
            .padding(.bottom, 20)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    @State static private var isLoggedIn = false
    
    static var previews: some View {
        RegisterView(isLoggedIn: $isLoggedIn)
    }
}
