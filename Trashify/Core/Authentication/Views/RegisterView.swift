//
//  RegisterView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    @State private var registerResult: Result<Void, RegisterError>?
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Join our community!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 30)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.headline)
                TextField("Enter your username", text: $registerViewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 15)
                Text("Email Address")
                    .font(.headline)
                TextField("Enter your email", text: $registerViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 15)
                Text("Password")
                    .font(.headline)
                SecureField("Enter your password", text: $registerViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 30)
                Text("Confirm Password")
                    .font(.headline)
                SecureField("Confirm your password", text: $registerViewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 30)
                
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            let result = await registerViewModel.register()
                            showAlert = true
                            registerResult = result
                        }
                    }) {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color(red: 48/255, green: 112/255, blue: 109/255))
                            .cornerRadius(15.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .font(.footnote)
                            .foregroundColor(Color(red: 48/255, green: 112/255, blue: 109/255))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 20)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            switch registerResult {
            case .failure(let error):
                return Alert(title: Text("Error"), message: Text(error.errorDescription ?? "Unknown Error"), dismissButton: .default(Text("OK")))
            default:
                return Alert(title: Text("Success"), message: Text("Registration successful"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
