//
//  ContentView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @EnvironmentObject var viewModel: LoginViewModel
    @EnvironmentObject var darkModeManager: DarkModeManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            if(isLoggedIn) {
                ContentAfterLoggedInView()
            } else {
                WelcomeScreenView(isLoggedIn: $isLoggedIn)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(darkModeManager.isDarkMode ? .dark : .light)
        .accentColor(AppColors.darkerGreen)
        .alert(isPresented: $viewModel.showLogoutAlert, content: {
            Alert(title: Text("Logged Out"), message: Text("You have been logged out successfully."), dismissButton: .default(Text("OK")) {
                isLoggedIn = false
            })
        })
        .alert(isPresented: $viewModel.showLogoutAlert, content: {
            Alert(title: Text("Logged Out"), message: Text("You have been logged out successfully."), dismissButton: .default(Text("OK")) {
                isLoggedIn = false
            })
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
