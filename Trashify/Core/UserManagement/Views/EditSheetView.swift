//
//  EditSheetView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

// Enum to distinguish between email and username updates
enum UpdateType {
    case email, username
}

// View for editing user details
struct EditSheetView: View {
    var title: String  // Title of the view
    var updateType: UpdateType  // Type of update (email or username)
    @Binding var isPresented: Bool  // Binding to control the presentation of the view
    @Binding var text: String  // Binding to the text field content
    @State private var showError: Bool = false  // State to control error message visibility
    @EnvironmentObject var userManagementViewModel: UserManagementViewModel  // ViewModel for user management
    @EnvironmentObject var darkModeManager: DarkModeManager  // Manager for dark mode settings

    var body: some View {
        VStack {
            // Title text
            Text(title)
                .bold()
                .font(.system(size: 20))
                .foregroundColor(Color.primary)
                .padding(.bottom, 20)
                .padding(.top, 30)
            
            // Text field for input
            HStack {
                TextField(title, text: $text)
                    .keyboardType(updateType == .email ? .emailAddress : .default)
                    .autocapitalization(.none)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.darkerGreen, lineWidth: 3)
                    )
                    // Update ViewModel on text change
                    .onChange(of: text) { newValue in
                        switch updateType {
                        case .email:
                            userManagementViewModel.newEmail = newValue
                        case .username:
                            userManagementViewModel.newUsername = newValue
                        }
                    }
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .cornerRadius(10)
            .padding(.horizontal)

            // Error message text
            if userManagementViewModel.errorMessage != nil {
                Text(userManagementViewModel.errorMessage ?? "Unknown error")
                    .foregroundColor(.red)
                    .padding(.bottom, 15)
                    .frame(width: UIScreen.main.bounds.width - 64)
            }

            // Save button
            Button(action: {
                switch updateType {
                case .email:
                    userManagementViewModel.updateEmail()
                case .username:
                    userManagementViewModel.updateUsername()
                }
            }) {
                Text("Save")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                    .background(AppColors.darkerGreen)
                    .cornerRadius(10)
                    .shadow(color: AppColors.darkerGreen.opacity(0.2), radius: 10, x: 0, y: 10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.horizontal)
    }
}

// Preview for the EditSheetView
struct EditSheetView_Previews: PreviewProvider {
    @State static var mockIsPresented: Bool = true
    @State static var mockText: String = "Example Text"
    
    static var previews: some View {
        EditSheetView(title: "Edit Email", updateType: .email, isPresented: $mockIsPresented,  text: $mockText)
    }
}
