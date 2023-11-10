//
//  UserManagementHeaderView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

struct UserManagementHeaderView: View {
    @Binding var selectedTab: Tab
    @EnvironmentObject var userManagementViewModel: UserManagementViewModel
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    
    var body: some View {
        VStack() {
            HStack {
                Button(action: {
                    selectedTab = .house
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                        Text("Home")
                            .bold()
                            .font(.system(size: 20))
                    }
                    .foregroundColor(Color.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 45))
                .foregroundColor(AppColors.lightGray)
                .padding(.top, 15)
                .padding(.bottom, 5)
            
            if userManagementViewModel.username.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .padding(.bottom, 50)
            } else {
                Text(userManagementViewModel.username)
                    .bold()
                    .font(.system(size: 24))
                    .padding(.bottom, 50)
                    .foregroundColor(Color.primary)
            }
        }
        .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        .onAppear(perform: userManagementViewModel.fetchUserData)
    }
}

struct UserManagementHeaderView_Previews: PreviewProvider {
    @State static var mockSelectedTab: Tab = .house
    
    static var previews: some View {
        UserManagementHeaderView(selectedTab: $mockSelectedTab)
    }
}
