//
//  UserManagementView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 15/09/2023.
//

import SwiftUI

struct UserManagementView: View {
    @EnvironmentObject var userManagementViewModel: UserManagementViewModel
    @EnvironmentObject var darkModeManager: DarkModeManager
    @State private var username: String = "Username"
    @State private var isDarkMode: Bool = false
    @State private var isEditUsernamePresented = false
    @State private var isEditEmailPresented = false
    @Binding var selectedTab: Tab

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                (darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                        .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer(minLength: geometry.safeAreaInsets.top / 3)
                    UserManagementContent()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(darkModeManager.isDarkMode ? Color(.systemBackground) : AppColors.lightGray)
                }
            }
        }
    }
    
    func openAppSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        }
    }

    func UserManagementContent() -> some View {
        VStack(spacing: 10) {
            UserManagementHeaderView(selectedTab: $selectedTab)
            UserDataView(isEditUsernamePresented: $isEditUsernamePresented, isEditEmailPresented: $isEditEmailPresented)
            AppSettingsView(openAppSettings: openAppSettings)
            SignOutView()
        }
        
        .sheet(isPresented: $isEditUsernamePresented) {
            EditSheetView(isPresented: $isEditUsernamePresented, title: "Update your username", text: $userManagementViewModel.newUsername, updateType: .username)
                .alert(isPresented: $userManagementViewModel.updateSuccess, content: {
                    Alert(title: Text("Update Successful"), message: Text("Username has been successfully updated."), dismissButton: .default(Text("OK")) {
                        isEditUsernamePresented = false
                    })
                })
        }
        .sheet(isPresented: $isEditEmailPresented) {
            EditSheetView(isPresented: $isEditEmailPresented, title: "Update your email", text: $userManagementViewModel.newEmail, updateType: .email)
                .alert(isPresented: $userManagementViewModel.updateSuccess, content: {
                    Alert(title: Text("Update Successful"), message: Text("Email address has been successfully updated. Please confirm your new email address."), dismissButton: .default(Text("OK")) {
                        isEditEmailPresented = false
                    })
                })
        }
    }
}


struct UserManagementView_Previews: PreviewProvider {
    @State static var mockSelectedTab: Tab = .house
    
    static var previews: some View {
        UserManagementView(selectedTab: $mockSelectedTab)
    }
}
