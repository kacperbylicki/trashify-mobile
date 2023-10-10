//
//  UserDataView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

struct UserDataView: View {
    @Binding var isEditUsernamePresented: Bool
    @Binding var isEditEmailPresented: Bool
    @EnvironmentObject var personTabViewModel: PersonTabViewModel
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    var body: some View {
        VStack() {
            HStack {
                Text("User data")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(Color.primary)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                HStack {
                    Image(systemName: "person")
                        .padding(.trailing, 5)
                    if personTabViewModel.username.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .padding(.bottom, 50)
                    } else {
                        Text(personTabViewModel.username)
                            .foregroundColor(Color.primary)
                    }
                }
                Spacer()
                Button(action: {
                    personTabViewModel.errorMessage = ""
                    personTabViewModel.newUsername = ""
                    isEditUsernamePresented = true
                }) {
                    Text("Edit")
                }
                .foregroundColor(AppColors.originalGreen)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            HStack {
                HStack {
                    Image(systemName: "envelope")
                        .accentColor(.black)
                    if personTabViewModel.email.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .padding(.bottom, 50)
                    } else {
                        Text(personTabViewModel.email)
                            .accentColor(Color.primary)
                    }
                }
                Spacer()
                Button(action: {
                    personTabViewModel.errorMessage = ""
                    personTabViewModel.newEmail = ""
                    isEditEmailPresented = true
                }) {
                    Text("Edit")
                }
                .foregroundColor(AppColors.originalGreen)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
        }
        .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
        .cornerRadius(20)
        .onAppear(perform: personTabViewModel.fetchUserData)
    }
}

struct UserDataView_Previews: PreviewProvider {
    @State static var mockEditUsername = false
    @State static var mockEditEmail = false
    
    static var previews: some View {
        UserDataView(isEditUsernamePresented: $mockEditUsername, isEditEmailPresented: $mockEditEmail)
    }
}

