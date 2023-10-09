//
//  PersonTabView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 15/09/2023.
//

import SwiftUI

struct PersonTabView: View {
    @EnvironmentObject var personTabViewModel: PersonTabViewModel
    @State private var username: String = "Username"
    @State private var isDarkMode: Bool = false
    @State private var isEditUsernamePresented = false
    @State private var isEditEmailPresented = false
    @Binding var selectedTab: Tab

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer(minLength: geometry.safeAreaInsets.top / 3)
                    PersonTabContent()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(AppColors.lightGray)
                }
            }
        }
    }
    
    func openAppSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        }
    }

    func PersonTabContent() -> some View {
        VStack(spacing: 10) {
            PersonHeaderView(selectedTab: $selectedTab)
            UserDataView(isEditUsernamePresented: $isEditUsernamePresented, isEditEmailPresented: $isEditEmailPresented)
            AppSettingsView(openAppSettings: openAppSettings, isDarkMode: $isDarkMode)
            SignOutView()
        }
        
        .sheet(isPresented: $isEditUsernamePresented) {
            EditSheetView(isPresented: $isEditUsernamePresented, title: "Update your username", text: $personTabViewModel.newUsername, updateType: .username)
                .alert(isPresented: $personTabViewModel.updateSuccess, content: {
                    Alert(title: Text("Update Successful"), message: Text("Username has been successfully updated."), dismissButton: .default(Text("OK")) {
                        isEditUsernamePresented = false
                    })
                })
        }
        .sheet(isPresented: $isEditEmailPresented) {
            EditSheetView(isPresented: $isEditEmailPresented, title: "Update your email", text: $personTabViewModel.newEmail, updateType: .email)
                .alert(isPresented: $personTabViewModel.updateSuccess, content: {
                    Alert(title: Text("Update Successful"), message: Text("Email address has been successfully updated."), dismissButton: .default(Text("OK")) {
                        isEditEmailPresented = false
                    })
                })
        }
    }
}


struct PersonTabView_Previews: PreviewProvider {
    @State static var mockSelectedTab: Tab = .house
    
    static var previews: some View {
        PersonTabView(selectedTab: $mockSelectedTab)
    }
}
