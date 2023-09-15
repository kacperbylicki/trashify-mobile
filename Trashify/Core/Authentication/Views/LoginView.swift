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
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome Back! 👋")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Hello again, you've been missed!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 30)
            
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                TextField("Enter email", text: $loginViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 15)
                Text("Password")
                    .font(.headline)
                SecureField("Enter password", text: $loginViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 30)
                
                HStack {
                    Spacer()
                    Button(action: {
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
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color(red: 48/255, green: 112/255, blue: 109/255))
                            .cornerRadius(15.0)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("OK"), action: {
                            showAlert = false
                        })
                        )
                    }
                    Spacer()
                }
                .padding()
            }
            
            HStack {
                Spacer()
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                        Text("Register")
                            .font(.footnote)
                            .foregroundColor(Color(red: 48/255, green: 112/255, blue: 109/255))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 20)
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static private var isLoggedIn = false
    
    static var previews: some View {
        LoginView(isLoggedIn: $isLoggedIn)
    }
}

